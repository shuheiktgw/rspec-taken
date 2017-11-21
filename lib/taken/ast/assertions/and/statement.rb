require 'taken/ast/ast_base'

module Taken
  module Ast
    module Assertions
      module And
        class Statement < Ast::AstBase

          attr_reader :spaces, :block

          def initialize(spaces:, block:)
            @spaces = spaces
            @block = block
          end

          def to_r
            "#{block.sentences}"
          end
        end
      end
    end
  end
end
