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
            "#{left.first.white_spaces}expect(#{ left.map(&:to_s).join }).to eq(#{ right.map(&:to_s).join })"
          end

          def newline?
            @left.first.newline?
          end

          def add_new_line!
            @left.first.add_new_line! unless newline?
            self
          end
        end
      end
    end
  end
end
