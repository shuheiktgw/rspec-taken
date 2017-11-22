require 'rufo'

module Taken
  class Generator

    attr_reader :parser, :writer

    def initialize(parser, writer)
      @parser = parser
      @writer = writer
    end

    def execute
      parsed = parser.parse_next

      until parsed.eof?
        writer.write(parsed.to_r)
        parsed = parser.parse_next
      end

      writer.close

      Rufo::Command.run([writer.new_file_path])
    rescue SystemExit => e
      puts "Format Completed. status :#{e.status}"
    end
  end
end
