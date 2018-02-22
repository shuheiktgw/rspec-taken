class Taken::AssertionTranspiler
  class << self
    def transpile(sentence)
      # TODO: Handle double equals elegantly
      return "expect(#{cleanup_sentence sentence}).to be_truthy" if more_than_two_eqs?(sentence)

      case sentence
      # expect(1).to eq(1) => expect(1).to eq(1)
      when /^\s*expect.+$/
        sentence
      # do_something == Failure(SomeError, /message/) => expect{ do_something }.to raise_error(SomeError, message)
      when /^\s*(.+)\s*==\s*Failure\(\s*([A-Za-z:]+)\s*,\s*(.+)\s*\)\s*$/
        "expect{ #{cleanup_sentence Regexp.last_match(1)} }.to raise_error(#{cleanup_sentence Regexp.last_match(2)}, #{cleanup_sentence Regexp.last_match(3)})"
      # do_something == Failure SomeError, /message/ => expect{ do_something }.to raise_error(SomeError, message)
      when /^\s*(.+)\s*==\s*Failure\s*([A-Za-z:]+)\s*,\s*(.+)\s*$/
        "expect{ #{cleanup_sentence Regexp.last_match(1)} }.to raise_error(#{cleanup_sentence Regexp.last_match(2)}, #{cleanup_sentence Regexp.last_match(3)})"
      # nil.nil? => expect(nil).to be_nil?
      when /^(.+)\.([^.\s]+)\?\s*$/
        "expect(#{cleanup_sentence Regexp.last_match(1)}).to be_#{cleanup_sentence Regexp.last_match(2)}"
      # false == false => expect(false).to be_falsey
      when /^\s*(.+)\s*==\s*false\s*$/
        "expect(#{cleanup_sentence Regexp.last_match(1)}).to be_falsey"
      # true != false => expect(false).not_to eq(false)
      when /^\s*(.+)\s*!=\s*(.+)\s*$/
        "expect(#{cleanup_sentence Regexp.last_match(1)}).not_to eq(#{cleanup_sentence Regexp.last_match(2)})"
      # 1 == 1 => expect(1).to eq(1)
      when /^\s*(.+)\s*==(.+)$/
        "expect(#{cleanup_sentence Regexp.last_match(1)}).to eq(#{cleanup_sentence Regexp.last_match(2)})"
      else
        "expect(#{cleanup_sentence sentence}).to be_truthy"
      end
    end

    private

    def cleanup_sentence(sentence)
      striped = sentence.strip
      while striped.start_with?('(') && striped.end_with?(')')
        striped.slice!(0)
        striped.slice!(-1)
      end
      striped
    end

    def more_than_two_eqs?(sentence)
      (sentence.scan('==').count > 1) && (sentence !~ /^\s*expect.+$/)
    end
  end
end
