module Taken
  class Loader
    FILE = 'file'.freeze
    DIRECTORY = 'directory'.freeze

    attr_reader :file_names, :file_idx, :file

    def initialize(file_path)
      @file_names = get_files(file_path)
      @file_idx = 0
    end

    def load_next_file
      if next_file_name.nil?
        @file = nil
        return false
      end

      @file = File.open(next_file_name, 'r')
      @file_idx += 1

      true
    end

    def next_file_name
      file_names[file_idx]
    end

    def current_file_name
      file_names[file_idx - 1]
    end

    private

    def get_files(path)
      file_type = File.ftype(path)

      names = if file_type == FILE
                raise 'The file does not end with _spec.rb.' unless path.end_with?('_spec.rb')
                [path]
              elsif file_type == DIRECTORY
                p = path.end_with?('/') ? path + '**/*' : path + '/**/*'
                Dir.glob(p).select { |f| f.end_with? '_spec.rb' }
              else
                raise 'Invalid path is given.'
      end

      raise 'The given path does not contain _spec.rb file.' if names.empty?
      names
    end
  end
end
