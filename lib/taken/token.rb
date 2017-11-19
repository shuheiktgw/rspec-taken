module Taken
  class Token
    attr_reader :type, :literal, :white_spaces

    EOF = 'EOF'
    UNKNOWN  = 'UNKNOWN'
    IDENT = 'IDENT'
    NUMBER = 'NUMBER'

    # Operators
    EQ = '=='

    # Delimiters
    LPAREN = '('
    RPAREN = ')'
    LBRACE = '{'
    RBRACE = '}'
    COLON = ':'

    # Keywords
    DO = 'DO'
    END_KEY = 'END'
    WHEN = 'WHEN'
    THEN = 'THEN'
    GIVEN = 'GIVEN'
    GIVEN_BANG = 'GIVEN!'

    KEYWORDS = {
      do: DO,
      end: END_KEY,
      When: WHEN,
      Then: THEN,
      Given: GIVEN,
      Given!: GIVEN_BANG
    }

    def self.lookup_ident(literal)
      KEYWORDS[literal.to_sym] || IDENT
    end

    def initialize(type:, literal:)
      @type = type
      @literal = literal
    end

    def attach_white_spaces(spaces)
      @white_spaces = spaces
      self
    end

    def block_closer?(starter)
      if self.type == Token::LBRACE
        starter.type == Token::RBRACE
      elsif self.type == Token::DO
        starter.type == Token::END_KEY
      else
        raise "Unknown block opener is specified: #{self.literal}"
      end
    end

    def newline?
      ["\n", "\r", "\r\n"].any? { |nl| self.white_spaces.include?(nl) }
    end

    def to_s(ignore_space=false)
      if ignore_space
        literal
      else
        white_spaces + literal
      end
    end

    def ==(other)
      self.instance_variables.map {|iv| self.instance_variable_get(iv) == other.instance_variable_get(iv)}.all?
    end
  end
end