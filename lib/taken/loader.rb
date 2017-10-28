module Taken
  class Loader
    FILE = 'file'
    DIRECTORY = 'directory'

    attr_reader :file_names, :file_idx, :content

    def initialize(file_path)
      @file_names = get_files(file_path)
      @file_idx = 0
    end

    def load_next
      if next_file_name.nil?
        @content = nil
        return false
      end

      @content = File.read(next_file_name)
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
      file_type = File::ftype(path)

      names = if file_type == FILE
        [path]
      elsif file_type == DIRECTORY
        Dir.glob('**' + path + '/*_spec.rb')
      else
        raise "Invalid path is given. path: #{path}"
      end

      raise "The given path #{path} does not contain .rb files." if names.empty?
      names
    end
  end
end