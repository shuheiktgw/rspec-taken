require 'taken/ast/ast_base'

module Taken
  module Ast
    module Then
      class NormalSentence < Ast::AstBase

        attr_reader :spaces, :keyword

        def initialize(spaces:, keyword:)
          @spaces = spaces
          @keyword = keyword
        end

        def to_r
          raise
        end
      end
    end
  end
end
