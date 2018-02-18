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
      # override is mainly used for testing, it transpiles test_spec.rb -> test_taken_spec.rb if false
      def taken(path, override = true)
        @@override = override

        succeed = []
        failed = []

        while loader(path).load_next_file
          begin
            generator.execute
            succeed << @loader.current_file_name
          rescue StandardError => e
            raise e
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
        ::Taken::Writer.new(file_path: @loader.current_file_name, override: @@override)
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
