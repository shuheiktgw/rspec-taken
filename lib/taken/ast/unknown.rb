require 'taken/ast/ast_base'

module Taken
  module Ast
    class Unknown < Ast::AstBase

      attr_reader :token

      def initialize(token:)
        @token = token
      end

      def to_r
        token.to_s
      end
    end
  end
end