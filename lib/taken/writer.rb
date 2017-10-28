module Taken
  class Writer

    attr_reader :file

    def initialize(file_path:)
      @file = File.open(file_path.gsub(/spec/, 'taken_spec'), 'w')
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