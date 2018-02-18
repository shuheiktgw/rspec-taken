require 'taken/loader'
require 'taken/reader'
require 'taken/lexer'
require 'taken/parser'
require 'taken/writer'
require 'taken/generator'
require 'taken/railtie' if defined?(Rails)

module Rspec
  module Taken
    class << self

      def taken(path)
        while loader(path).load_next_file
          generator.execute
        end
      end

      def files
        @loader.file_names
      end

      private

      def loader(path)
        @loader ||= ::Taken::Loader.new(path)
      end

      def reader
        ::Taken::Reader.new(@loader.file)
      end

      def lexer
        ::Taken::Lexer.new(reader)
      end

      def parser
        ::Taken::Parser.new(lexer)
      end

      def writer
        ::Taken::Writer.new(file_path: @loader.current_file_name)
      end

      def generator
        ::Taken::Generator.new(parser, writer)
      end
    end
  end
end
