require 'taken/ast/ast_base'

module Taken
  module Ast
    class PlainSentence < Ast::AstBase

      attr_reader :tokens

      def initialize(tokens)
        @tokens = tokens
      end

      def to_r
        tokens.map(&:to_s).join
      end
    end
  end
end
