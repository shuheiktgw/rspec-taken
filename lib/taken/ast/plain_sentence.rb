require 'taken/ast/ast_base'

module Taken
  module Ast
    class PlainSentence < Ast::AstBase

      attr_reader :tokens

      def initialize(tokens)
        @tokens = tokens
      end

      def to_r
        "#{tokens.map(&:to_s).join}"
      end

      def new_line?
        tokens.first.new_line?
      end

      def add_new_line!
        tokens.first.add_new_line! unless new_line?
      end
    end
  end
end
