require 'taken/ast/ast_base'

module Taken
  module Ast
    module Assertions
      class AssertionSentence < Ast::AstBase

        attr_reader :tokens

        def initialize(tokens)
          @tokens = tokens
        end

        def to_r
          AssertionTranspiler.transpile(assertion_sentence)
        end

        def newline?
          tokens.first.newline?
        end

        # Ignore the first newline to avoid like the case below.
        # \n Then { something == something } => expect(\n something).to eq(something)
        def assertion_sentence
          tokens.map.with_index do |t, i|
            if i == 0
              t.to_s(true)
            else
              t.to_s
            end
          end.join
        end

        def add_new_line!
          tokens.first.add_new_line! unless newline?
          self
        end
      end
    end
  end
end
