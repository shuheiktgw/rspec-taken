require 'taken/ast/ast_base'
require 'taken/token'

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
        multiply_block

        new_lined_another_sentences = another_sentences.map.with_index do |as, i|
          as.add_new_line! if i == 0
        end

        @sentences = @sentences + new_lined_another_sentences
        self
      end

      private

      def multiply_block
        @opener = Token.new(type: Token::DO, literal: 'do').attach_white_spaces opener.white_spaces
        @closer = Token.new(type: Token::END_KEY, literal: 'end').attach_white_spaces closer.white_spaces

        @closer.add_new_line! unless @closer.newline?
        @sentences.first.add_new_line!
      end
    end
  end
end
