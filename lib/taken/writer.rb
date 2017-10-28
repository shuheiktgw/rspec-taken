module Taken
  class Writer

    attr_reader :file

    def initialize(file_path:)
      fp = file_path.gsub!(/_spec.rb/, '_taken_spec.rb')
      raise "Invalid file path is given. file_path: #{file_path}" if fp.nil?

      @file = File.open(fp, 'w')
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