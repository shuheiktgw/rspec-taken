require 'rufo'

module Taken
  class Generator
    attr_reader :parser, :writer, :current_ast, :next_ast

    def initialize(parser, writer)
      @parser = parser
      @writer = writer

      get_next
      get_next
    end

    def execute
      until current_ast.eof?
        writer.write(current_ast.generate_code(self))
        get_next
      end

      writer.close

      Rufo::Command.run([writer.new_file_path])
    rescue SystemExit => e
      e.status != 1
    end

    def get_next
      @current_ast = @next_ast
      @next_ast = parser.parse_next
    end
  end
end
