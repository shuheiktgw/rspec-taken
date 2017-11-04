require 'spec_helper'
require 'stringio'
require 'taken/parser'
require 'taken/lexer'
require 'taken/reader'
require 'taken/token'

RSpec.describe Taken::Parser do

  let(:parser) { Taken::Parser.new(lexer) }
  let(:lexer) { Taken::Lexer.new(reader) }
  let(:reader) { Taken::Reader.new(file) }

  describe '#next_token' do
    subject(:parsed){ parser.parse_next }
    let(:file) { StringIO.new(content, 'r') }

    context 'when Given is given' do
      let(:content) { 'Given(:initial_contents) { [:second_item, :top_item] }' }

      it 'parsed given declaration' do
        expect(parsed.spaces).to eq ''
        expect(parsed.keyword).to eq 'initial_contents'
      end
    end
  end
end