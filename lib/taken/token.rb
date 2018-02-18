module Taken
  class Token
    attr_reader :type, :literal, :white_spaces

    EOF = 'EOF'.freeze
    UNKNOWN = 'UNKNOWN'.freeze
    IDENT = 'IDENT'.freeze
    NUMBER = 'NUMBER'.freeze

    # Operators
    EQ = '=='.freeze

    # Delimiters
    LPAREN = '('.freeze
    RPAREN = ')'.freeze
    LBRACE = '{'.freeze
    RBRACE = '}'.freeze
    COLON = ':'.freeze
    SINGLE_QUOTE = "'".freeze
    DOUBLE_QUOTE = '"'.freeze

    # Keywords
    DO = 'DO'.freeze
    END_KEY = 'END'.freeze
    WHEN = 'WHEN'.freeze
    THEN = 'THEN'.freeze
    AND = 'AND'.freeze
    GIVEN = 'GIVEN'.freeze
    GIVEN_BANG = 'GIVEN!'.freeze

    KEYWORDS = {
      do: DO,
      end: END_KEY,
      When: WHEN,
      Then: THEN,
      And: AND,
      Given: GIVEN,
      Given!: GIVEN_BANG
    }.freeze

    def self.lookup_ident(literal)
      KEYWORDS[literal.to_sym] || IDENT
    end

    def initialize(type:, literal:, white_spaces: '')
      @type = type
      @literal = literal
      @white_spaces = white_spaces
    end

    def attach_white_spaces(spaces)
      @white_spaces = spaces
      self
    end

    def block_closer?(starter)
      if type == Token::LBRACE
        starter.type == Token::RBRACE
      elsif type == Token::DO
        starter.type == Token::END_KEY
      else
        raise "Unknown block opener is specified: #{literal}"
      end
    end

    def newline?
      ["\n", "\r", "\r\n"].any? { |nl| white_spaces.include?(nl) }
    end

    def add_new_line!
      @white_spaces << "\n"
      self
    end

    def to_s(ignore_space = false)
      if ignore_space
        literal
      else
        "#{white_spaces}#{literal}"
      end
    end

    def ==(other)
      instance_variables.map { |iv| instance_variable_get(iv) == other.instance_variable_get(iv) }.all?
    end
  end
end
