require 'pry'
require 'taken/token'
require 'taken/ast/given_declaration'
require 'taken/ast/unknown'

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

    def get_next
      @current_token = @next_token
      @next_token = lexer.next_token
    end
  end
end