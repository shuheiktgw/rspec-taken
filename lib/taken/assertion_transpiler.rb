class Taken::AssertionTranspiler
  class << self
    def transpile(sentence)
      case sentence
      # expect(1).to eq(1) => expect(1).to eq(1)
      when /^\s*expect.+$/
        sentence
      # do_something == Failure(SomeError, /message/) => expect{ do_something }.to raise_error(SomeError, message)
      when /^\s*(\S+)\s*==\s*Failure\(?([A-Za-z]+),\s*([^)]+)\s*\)?\s*$/
        "expect{ #{$1} }.to raise_error(#{$2}, #{$3})"
      # 1 == 1 => expect(1).to eq(1)
      # TODO: Handle double equals
      when /^\s*(\S+)\s*==\s*(\S+)\s*$/
        "expect(#{$1}).to eq(#{$2})"
      else
        "expect(#{sentence}).to be_truthy"
      end
    end
  end
end
