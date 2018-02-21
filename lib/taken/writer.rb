module Taken
  class Writer
    attr_reader :file, :new_file_path

    def initialize(file_path:, overwrite:)
      raise "File should end with _spec.rb. file_path: #{file_path}" unless file_path.end_with?('_spec.rb')
      @new_file_path = overwrite ? file_path : file_path.gsub(/_spec.rb/, '_taken_spec.rb')

      @file = File.open(@new_file_path, 'w')
    end

    def write(content)
      file.write(content)
    end

    def close
      file.flush
      file.close
    end
  end
end
