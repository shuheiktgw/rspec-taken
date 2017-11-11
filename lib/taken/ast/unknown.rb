require 'taken/ast/ast_base'

module Taken
  module Ast
    class Unknown < Ast::AstBase

      attr_reader :token

      def initialize(token:)
        @token = token
      end

      def spaces
        token.white_spaces
      end

      def literal
        token.literal
      end

      def to_r
        "#{spaces}#{literal}"
      end
    end
  end
end