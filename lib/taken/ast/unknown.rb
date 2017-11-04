module Taken
  module Ast
    class Unknown

      attr_reader :token

      def initialize(token:)
        @token = token
      end

      def to_r
        "#{token.spaces}#{token.literal}"
      end
    end
  end
end