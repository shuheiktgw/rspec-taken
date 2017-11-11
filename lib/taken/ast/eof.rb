require 'taken/ast/ast_base'

module Taken
  module Ast
    class EOF < Ast::AstBase
      def eof?
        true
      end
    end
  end
end