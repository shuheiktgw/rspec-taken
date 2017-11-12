require 'taken/loader'
require 'taken/reader'
require 'taken/lexer'
require 'taken/parser'
require 'taken/writer'
require 'taken/generator'

module Taken
  class << self
    def taken(path)
      while loader(path).load_next_file
        generator.execute
      end
    end

    private

    def loader(path)
      @loader ||= Loader.new(path)
    end

    def reader
      Reader.new(loader.file)
    end

    def lexer
      Lexer.new(reader)
    end

    def parser
      Parser.new(lexer)
    end

    def writer
      Writer.new(loader.current_file_name)
    end

    def generator
      Generator.new(parser, writer)
    end
  end
end
