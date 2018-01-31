require 'taken/ast/ast_base'

module Taken
  module Ast
    module When
      class ParenStatement < Ast::AstBase

        attr_reader :spaces, :keyword

        def initialize(spaces:, keyword:)
          @spaces = spaces
          @keyword = keyword
        end

        def generate_code(_generator)
          self.to_r
        end

        def to_r
          "#{spaces}let!(#{keyword})"
        end
      end
    end
  end
end
