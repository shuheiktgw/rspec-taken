require 'spec_helper'
require 'stringio'
require 'taken/reader'
require 'taken/token'

RSpec.describe Taken::Reader do
  let(:file) { StringIO.new(content, 'r') }

  describe '#readcher' do
    let(:content) { '12' }

    it 'reads char' do
      lexer = described_class.new(file)
      expect(lexer.current_char).to eq '1'
      expect(lexer.next_char).to eq '2'

      lexer.readchar
      expect(lexer.current_char).to eq '2'
      expect(lexer.next_char).to eq Taken::Token::EOF

      lexer.readchar
      expect(lexer.current_char).to eq Taken::Token::EOF
      expect(lexer.next_char).to be_nil

      lexer.readchar
      expect(lexer.current_char).to eq Taken::Token::EOF
      expect(lexer.next_char).to be_nil

      lexer.readchar
      expect(lexer.current_char).to eq Taken::Token::EOF
      expect(lexer.next_char).to be_nil
    end
  end
end
