require 'pry'
require 'taken/token'

module Taken
  class Lexer

    attr_reader :reader

    def initialize(reader)
      @reader = reader
    end

    def next_token
      binding.pry
      eaten = eat_white_spaces

      token = case current_char
      when '=' # = or == or === ?
        if next_char == '='
          reader.readchar

          # == or === ?
          if next_char == '='
            reader.readchar
            Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '===')
          else
            Taken::Token.new(type: Taken::Token::EQ, literal: '=')
          end
        else
          Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '=')
        end
      end

      reader.readchar

      token.attach_white_spaces(eaten)
    end

    private

    def read_identifier
      str = current_char

      while (letter? next_char) || (digit? next_char)
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

    def current_char
      reader.current_char
    end

    def next_char
      reader.next_char
    end
  end
end