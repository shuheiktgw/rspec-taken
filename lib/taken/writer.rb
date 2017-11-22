module Taken
  class Writer

    attr_reader :file, :new_file_path

    def initialize(file_path:)
      @new_file_path = file_path.gsub!(/_spec.rb/, '_taken_spec.rb')
      raise "Invalid file path is given. file_path: #{file_path}" if @new_file_path.nil?

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