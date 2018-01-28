require 'taken/ast/ast_base'

module Taken
  module Ast
    module Given
      class BraceStatement < Ast::AstBase

        attr_reader :spaces, :block

        def initialize(spaces:, block:)
          @spaces = spaces
          @block = block
        end

        def generate_code(_generator)
          self.to_r
        end

        def to_r
          "#{spaces}before#{block.to_r}"
        end
      end
    end
  end
end
