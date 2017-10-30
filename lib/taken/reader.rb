module Taken
  class Reader
    attr_reader :file, :current_char, :next_char

    def initialize(file)
      @file = file
      readchar
      readchar
    end

    def readchar
      @current_char = @next_char
      @next_char = file.readchar
    rescue EOFError
      @next_char = Taken::Token::EOF
      file.close
    rescue IOError
      @current_char = Taken::Token::EOF
      @next_char = nil
    end
  end
end