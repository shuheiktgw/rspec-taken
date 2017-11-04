module Taken
  module Ast
    class GivenDeclaration

      attr_reader :spaces, :keyword

      def initialize(spaces:, keyword:)
        @spaces = spaces
        @keyword = keyword
      end

      def to_r
        "#{spaces}let(:#{keyword})"
      end
    end
  end
end
