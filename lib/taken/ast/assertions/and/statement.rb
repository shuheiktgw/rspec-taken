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
            raise 'Cannot call and to_r of And Statement. Something must be wrong with the logic.'
          end
        end
      end
    end
  end
end
