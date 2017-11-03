require 'pry'
require 'taken/token'

module Taken
  class Parser

    attr_reader :lexer

    def initialize(lexer)
      @lexer = lexer
    end

    def parse_next

    end

    def next_token
      lexer.next_token
    end
  end
end