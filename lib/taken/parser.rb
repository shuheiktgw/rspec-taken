require 'taken/token'
require 'taken/ast/unknown'
require 'taken/ast/eof'
require 'taken/ast/block'
require 'taken/ast/plain_sentence'
require 'taken/ast/let_bang_statement'
require 'taken/ast/before_statement'
require 'taken/ast/given/paren_statement'
require 'taken/ast/assertions/then/statement'
require 'taken/ast/assertions//then/assertion_sentence'
require 'taken/ast/assertions/and/statement'
require 'taken/ast/assertions//and/assertion_sentence'

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
        parse_assertion(Ast::Assertions::Then::Statement, Ast::Assertions::Then::AssertionSentence)
      when Token::AND
        parse_assertion(Ast::Assertions::And::Statement, Ast::Assertions::And::AssertionSentence)
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

    def parse_assertion(statement_class, assertion_klass)
      spaces = current_token.white_spaces

      expect_next(Token::LBRACE, Token::DO) # Then -> { or do

      block = parse_block do |tokens, is_last|
        eq_count = tokens.count {|t| t.type == Token::EQ }

        if eq_count == 0
          Ast::PlainSentence.new(tokens)
        elsif eq_count == 1
          idx = tokens.index{ |token| token.type == Token::EQ }
          assertion_klass.new(left: tokens[0...idx], right: tokens[idx+1..-1])
        else
          raise "Cannot parse assertion statement with more than two == tokens. got: #{eq_count}"
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

      until (!tokens.empty? && current_token.newline?) || opener.block_closer?(current_token)
        tokens << current_token
        get_next
      end

      yield tokens, opener.block_closer?(current_token)
    end

    def expect_next(*expected)
      if expected.include?(@next_token.type)
        get_next
      else
        raise ParseError, "Expected next token to be #{expected.join(' or ')}. Got: #{@next_token.type}"
      end
    end

    def get_next
      @current_token = @next_token
      @next_token = lexer.next_token
    end
  end
end
