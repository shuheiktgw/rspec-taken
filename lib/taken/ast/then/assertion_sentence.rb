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
          "#{left.first.white_spaces}expect(#{left.map{|t| t.to_s(true) }.join}).to eq(#{right.map{|t| t.to_s(true) }.join})"
        end
      end
    end
  end
end
