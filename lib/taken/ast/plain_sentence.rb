require 'taken/ast/ast_base'

module Taken
  module Ast
    class PlainSentence < Ast::AstBase

      attr_reader :tokens

      def initialize(tokens)
        @tokens = tokens
      end

      def generate_code(_generator)
        self.to_r
      end

      def to_r
        "#{tokens.map(&:to_s).join}"
      end

      def newline?
        tokens.first.newline?
      end

      def add_new_line!
        tokens.first.add_new_line! unless newline?
        self
      end

      def ==(other)
        tokens.map.with_index{ |t, i| t == other.tokens[i] }.all?
      end
    end
  end
end
