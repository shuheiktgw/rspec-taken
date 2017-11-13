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
      block = parse_then_block
    end

    def parse_then_block
      opener = current_token

      get_next

      sentences = parse_then_sentence
      while current_token.type != select_closer(opener)
        sentences << parse_then_sentence
      end

      get_next

      sentences
    end

    def parse_then_sentence

    end

    def select_closer(opener)
      if opener.type == Token::LBRACE
        Token::RBRACE
      elsif opener.type == Token::DO
        Token::END
      else
        raise "Unknown opener is specified: #{opener.literal}"
      end
    end

    def get_next
      @current_token = @next_token
      @next_token = lexer.next_token
    end
  end
end