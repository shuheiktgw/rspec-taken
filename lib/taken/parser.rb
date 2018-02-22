require 'taken/token'
require 'taken/ast/unknown'
require 'taken/ast/eof'
require 'taken/ast/block'
require 'taken/ast/plain_sentence'
require 'taken/ast/let_bang_statement'
require 'taken/ast/before_statement'
require 'taken/ast/given/paren_statement'
require 'taken/ast/assertions/then/statement'
require 'taken/ast/assertions/assertion_sentence'
require 'taken/ast/assertions/and/statement'
require 'byebug'

module Taken
  class Parser
    class ParseError < StandardError; end

    attr_reader :lexer, :current_token, :next_token

    def initialize(lexer)
      @lexer = lexer
      get_next
      get_next
    end

    def parse_next
      parsed = case current_token.type
               when Token::GIVEN
                 if next_token.type == Token::LPAREN # Given(:key) { some_value } / Given(:key) do ~ end
                   parse_let(Ast::Given::ParenStatement)
                 elsif next_token.type == Token::LBRACE || next_token.type == Token::DO # Given { some_method } / Given do ~ end
                   parse_before
                 else
                   Ast::Unknown.new(token: current_token)
                 end
               when Token::WHEN
                 if next_token.type == Token::LPAREN # When(:key) { some_value } / When(:key) do ~ end
                   parse_let(Ast::LetBangStatement)
                 elsif next_token.type == Token::LBRACE || next_token.type == Token::DO # Given { some_method } / Given do ~ end
                   parse_before
                 else
                   Ast::Unknown.new(token: current_token)
                 end
               when Token::GIVEN_BANG
                 parse_let(Ast::LetBangStatement)
               when Token::THEN
                 parse_assertion(Ast::Assertions::Then::Statement)
               when Token::AND
                 parse_assertion(Ast::Assertions::And::Statement)
               when Token::EOF
                 Ast::EOF.new
               else
                 Ast::Unknown.new(token: current_token)
      end

      get_next
      parsed
    end

    private

    def parse_let(klass)
      spaces = current_token.white_spaces

      expect_next(Token::LPAREN) # Given / Given! -> (
      expect_next(Token::COLON, Token::SINGLE_QUOTE, Token::DOUBLE_QUOTE) # (     -> : or ' or "

      keyword = ''

      while current_token.type != Token::RPAREN
        keyword << current_token.literal
        get_next
      end

      klass.new(spaces: spaces, keyword: keyword)
    end

    def parse_before
      spaces = current_token.white_spaces

      expect_next(Token::LBRACE, Token::DO) # Given -> { / do

      block = parse_block { |tokens, _is_last| Ast::PlainSentence.new(tokens) }

      Ast::BeforeStatement.new(spaces: spaces, block: block)
    end

    def parse_assertion(statement_class)
      spaces = current_token.white_spaces

      expect_next(Token::LBRACE, Token::DO) # Then -> { or do

      block = parse_block do |tokens, is_last|
        if is_last
          Ast::Assertions::AssertionSentence.new(tokens)
        else
          Ast::PlainSentence.new(tokens)
        end
      end

      statement_class.new(spaces: spaces, block: block)
    end

    def parse_block
      opener = current_token

      get_next

      sentences = []
      until opener.block_closer?(current_token)
        sentences << parse_block_sentence(opener) do |tokens, is_last|
          yield tokens, is_last
        end
      end

      closer = current_token

      Ast::Block.new(opener: opener, sentences: sentences, closer: closer)
    end

    def parse_block_sentence(opener)
      tokens = []
      # A number of block opener encountered when parsing block
      # Since block might contain another block, opener_count should be zero when stop parsing
      # The example blow contains two {}s inside Then block
      # ex. Then { "something"  == "#{var1}#{var2}"}
      opener_count = 0

      until (!tokens.empty? && current_token.newline?) || (opener.block_closer?(current_token) && opener_count == 0)
        opener_count += 1 if opener.type == current_token.type
        opener_count -= 1 if opener.block_closer?(current_token)

        tokens << current_token
        get_next
      end

      yield tokens, opener.block_closer?(current_token)
    end

    def expect_next(*expected)
      return get_next if expected.include?(@next_token.type)
      raise ParseError, "Expected next token to be #{expected.join(' or ')}. Got: #{@next_token.type}"
    end

    def get_next
      @current_token = @next_token
      @next_token = lexer.next_token
    end
  end
end
