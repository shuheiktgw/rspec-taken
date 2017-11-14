require 'taken/ast/ast_base'

module Taken
  module Ast
    module Then
      class AssertionSentence < Ast::AstBase

        attr_reader :left, :right

        def initialize(left:, right:)
          @left = left
          @right = right
        end

        def to_r
          "expect(#{left.map(&:to_s).join}).to eq(#{right.map(&:to_s).join})"
        end
      end
    end
  end
end
