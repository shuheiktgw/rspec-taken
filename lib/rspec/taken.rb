require 'taken/loader'
require 'taken/reader'
require 'taken/lexer'
require 'taken/parser'
require 'taken/writer'
require 'taken/generator'
require 'taken/railtie' if defined?(Rails)

module Rspec
  module Taken
    class FormatError < StandardError; end

    class << self
      # override is mainly used for testing
      def taken(path, development = true)
        @development = development

        succeed = []
        failed = []

        while loader(path).load_next_file
          begin
            return succeed << @loader.current_file_name if generator.execute
            raise FormatError, 'Something seems to be wrong with transpiling the file and stop formatting...'
          rescue StandardError => e
            raise e if @development
            failed << report_failure(@loader.current_file_name, e.message)
          end
        end

        [succeed, failed]
      end

      private

      Failure = Struct.new :file_name, :message

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
        ::Taken::Writer.new(file_path: @loader.current_file_name, overwrite: !@development)
      end

      def generator
        ::Taken::Generator.new(parser, writer)
      end

      def report_failure(file_name, message)
        Failure.new(file_name, message)
      end
    end
  end
end
