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

    def to_s
      "#{white_spaces}#{literal}"
    end

    def ==(other)
      self.instance_variables.map {|iv| self.instance_variable_get(iv) == other.instance_variable_get(iv)}.all?
    end
  end
end