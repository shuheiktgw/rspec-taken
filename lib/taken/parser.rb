require 'taken/token'
require 'taken/ast/given_declaration'
require 'taken/ast/unknown'
require 'taken/ast/eof'
require 'taken/ast/then/statement'
require 'taken/ast/block'
require 'taken/ast/then/normal_sentence'
require 'taken/ast/then/assertion_sentence'
require 'pry'

module Taken
  class Parser

    attr_reader :lexer, :current_token, :next_token

    def initialize(lexer)
      @lexer = lexer
      get_next
      get_next
    end

    # Memo: When, Given! is still until encounters unclosed end keyword
    def parse_next
      parsed = case current_token.type
      when Token::GIVEN
        parse_given
      when Token::THEN
        parse_then
      when Token::EOF
        Ast::EOF.new
      else
        Ast::Unknown.new(token: current_token)
      end

      get_next
      parsed
    end

    private

    def parse_given
      spaces = current_token.white_spaces

      get_next # Given -> (
      get_next # (     -> : or ' or "

      keyword = ''

      while current_token.type != Token::RPAREN
        keyword << current_token.literal
        get_next
      end

      Ast::GivenDeclaration.new(spaces: spaces, keyword: keyword)
    end

    def parse_then
      spaces = current_token.white_spaces

      get_next # Then -> { or do

      block = parse_block do |tokens|
        eq_count = tokens.count {|t| t.type == Token::EQ }

        if eq_count == 0
          Ast::Then::NormalSentence.new(tokens)
        elsif eq_count == 1
          idx = tokens.index{ |token| token.type == Token::EQ }
          Ast::Then::AssertionSentence.new(left: tokens[0...idx], right: tokens[idx+1..-1])
        else
          raise "Cannot parse then statement with more than two == tokens. got: #{eq_count}"
        end
      end

      Ast::Then::Statement.new(spaces: spaces, block: block)
    end

    def parse_block
      opener = current_token

      get_next

      sentences = []
      until opener.block_closer?(current_token)
        sentences << parse_block_sentence(opener) do |tokens|
          yield tokens
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

      yield tokens
    end

    def form_then_sentence(tokens)

    end

    def get_next
      @current_token = @next_token
      @next_token = lexer.next_token
    end
  end
end