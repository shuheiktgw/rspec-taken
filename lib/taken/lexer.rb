require 'pry'
require 'taken/token'

module Taken
  class Lexer

    attr_reader :reader

    def initialize(reader)
      @reader = reader
    end

    def next_token
      eaten = eat_white_spaces

      token = case current_char
      when '=' # = or == or === ?
        if next_char == '='
          reader.readchar

          # == or === ?
          if next_char == '='
            reader.readchar
            Token.new(type: Token::UNKNOWN, literal: '===')
          else
            Token.new(type: Taken::Token::EQ, literal: '==')
          end
        else
          Token.new(type: Token::UNKNOWN, literal: '=')
        end
      when '('
        Token.new(type: Token::LPAREN, literal: '(')
      when ')'
        Token.new(type: Token::RPAREN, literal: ')')
      when '{'
        Token.new(type: Token::LBRACE, literal: '{')
      when '}'
        Token.new(type: Token::RBRACE, literal: '}')
      when ':'
        Token.new(type: Token::COLON, literal: ':')
      when 'EOF'
        Token.new(type: Token::EOF, literal: 'EOF')
      else
        if letter? current_char
          literal = read_identifier
          type = Token.lookup_ident(literal)

          Token.new(type: type, literal: literal)
        elsif digit? current_char
          Token.new(type: Token::NUMBER, literal: read_number)
        else
          Token.new(type: Token::UNKNOWN, literal: current_char)
        end
      end

      reader.readchar

      token.attach_white_spaces(eaten)
    end

    private

    def read_identifier
      str = current_char

      while (letter? next_char) || (digit? next_char) || (allowed_chars? next_char)
        reader.readchar
        str << current_char
      end

      str
    end

    def eat_white_spaces
      white_spaces = [' ', "\t", "\n", "\r"]

      eaten =''
      while white_spaces.include? current_char
        eaten << current_char
        reader.readchar
      end
      eaten
    end

    def letter?(ch)
      ch =~ /^[a-zA-Z_]$/
    end

    def digit?(ch)
      ch =~ /^[0-9]$/
    end

    def allowed_chars?(ch)
      ch =~ /^[-!]$/
    end

    def current_char
      reader.current_char
    end

    def next_char
      reader.next_char
    end
  end
end