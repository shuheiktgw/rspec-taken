require 'taken/ast/ast_base'

module Taken
  module Ast
    module Assertions
      module Then
        class Statement < Ast::AstBase
          attr_reader :spaces, :block

          def initialize(spaces:, block:)
            @spaces = spaces
            @block = block
          end

          def generate_code(generator)
            while generator.next_ast.is_a? Ast::Assertions::And::Statement
              generator.get_next
              merge_and!(generator.current_ast)
            end

            to_r
          end

          def merge_and!(and_statement)
            @block = block.merge_sentences(and_statement.merged_sentences)
            self
          end

          def to_r
            "#{spaces}it#{block.to_r}"
          end
        end
      end
    end
  end
end
