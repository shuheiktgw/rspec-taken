require 'taken/ast/ast_base'

module Taken
  module Ast
    class Block < Ast::AstBase

      attr_reader :opener, :sentences, :closer

      def initialize(opener:, sentences:, closer:)
        @opener = opener
        @sentences = sentences
        @closer = closer
      end

      def to_r
        "#{opener.to_s}#{sentences.map(&:to_r).join}#{closer.to_s}"
      end

      def merge_sentences(another_sentences)
        left_spaces = @sentences.last.left_spaces
        space_injected = another_sentences.map{ |as| as.left_spaces = left_spaces }

        @sentences << space_injected
      end
    end
  end
end
