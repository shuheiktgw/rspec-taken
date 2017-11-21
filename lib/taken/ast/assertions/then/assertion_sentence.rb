require 'taken/ast/ast_base'

module Taken
  module Ast
    module Assertions
      module Then
        class AssertionSentence < Ast::AstBase

          attr_reader :left, :right

          def initialize(left:, right:)
            @left = left
            @right = right
          end

          def to_r
            "#{left.first.white_spaces}expect(#{form_sentence left}).to eq(#{form_sentence right})"
          end

          def form_sentence(tokens)
            tokens.map.with_index do |t, i|
              if i == 0
                t.to_s(true)
              else
                t.to_s
              end
            end.join
          end
        end
      end
    end
  end
end
