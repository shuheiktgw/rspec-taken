require 'taken/ast/ast_base'

module Taken
  module Ast
    class PlainSentence < Ast::AstBase

      attr_accessor :left_spaces
      attr_reader :tokens

      def initialize(tokens)
        @left_spaces = tokens.first.white_spaces
        @tokens = tokens
      end

      def to_r
        "#{left_spaces}#{form_sentence tokens}"
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
