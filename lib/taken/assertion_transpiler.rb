class Taken::AssertionTranspiler
  class << self
    def transpile(sentence)
      case sentence
      when /^\s*(\S+)\s*==\s*(\S+)\s*$/ # 1 = 1 => expect(1).to eq(1)
        "expect(#{$1}).to eq(#{$2})"
      # TODO: Handle double equals
      end
    end
  end
end
