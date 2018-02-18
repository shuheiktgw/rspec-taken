require 'rufo'

module Taken
  class Generator
    attr_reader :parser, :writer

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
      puts "Format Completed. status :#{e.status}"
    end

    attr_reader :current_ast

    attr_reader :next_ast

    def get_next
      @current_ast = @next_ast
      @next_ast = parser.parse_next
    end
  end
end
