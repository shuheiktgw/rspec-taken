require 'taken/token'
require 'taken/ast/given_declaration'
require 'taken/ast/unknown'
require 'taken/ast/eof'

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

      block = parse_then_block

      Ast::Then::Statement.new(spaces: spaces, block: block)
    end

    def parse_then_block
      opener = current_token

      get_next

      sentences = parse_then_sentence(opener)
      while opener.block_closer?(current_token)
        sentences << parse_then_sentence(opener)
      end

      closer = current_token

      get_next

      sentences

      Ast::Then::Block.new(opener: opener, sentences: sentences, closer: closer)
    end

    def parse_then_sentence(opener)
      tokens = []
      eq_count = 0

      until current_token.newline? || opener.block_closer?(current_token)
        tokens << current_token
        eq_count += 1 if current_token.type == Token::EQ

        get_next
      end

      form_then_sentence tokens, eq_count
    end

    def form_then_sentence(tokens, eq_count)
      if eq_count == 0
        Ast::Then::NormalSentence.new(tokens)
      elsif eq_count == 1
        idx = tokens.index{ |token| token.type == Token::EQ }
        Ast::Then::AssertionSentence.new(left: tokens[0...idx], right: tokens[idx+1..-1])
      else
        raise "Cannot parse then statement with more than two == tokens. got: #{eq_count}"
      end
    end

    def get_next
      @current_token = @next_token
      @next_token = lexer.next_token
    end
  end
end