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
      let(:content) {"Given(#{key}) { [:second_item, :top_item] }"}

      context 'key is symnol' do
        let(:key) { ':initial_contents' }

        context 'parsed once' do
          it 'parsed given declaration' do
            expect(parsed.spaces).to eq ''
            expect(parsed.keyword).to eq ':initial_contents'
          end
        end

        context 'parsed twice' do
          before do
            parser.parse_next
          end

          it 'parsed Unknown {' do
            expect(parsed.spaces).to eq ' '
            expect(parsed.literal).to eq '{'
          end
        end
      end

      context 'key is single quoted' do
        let(:key) { "'initial_contents'" }

        context 'parsed once' do
          it 'parsed given declaration' do
            expect(parsed.spaces).to eq ''
            expect(parsed.keyword).to eq "'initial_contents'"
          end
        end

        context 'parsed twice' do
          before do
            parser.parse_next
          end

          it 'parsed Unknown {' do
            expect(parsed.spaces).to eq ' '
            expect(parsed.literal).to eq '{'
          end
        end
      end

      context 'key is double quoted' do
        let(:key) { '"initial_contents"' }

        context 'parsed once' do
          it 'parsed given declaration' do
            expect(parsed.spaces).to eq ''
            expect(parsed.keyword).to eq '"initial_contents"'
          end
        end

        context 'parsed twice' do
          before do
            parser.parse_next
          end

          it 'parsed Unknown {' do
            expect(parsed.spaces).to eq ' '
            expect(parsed.literal).to eq '{'
          end
        end
      end
    end

    context 'when EOF is given' do
      let(:content) { '' }

      context 'parsed once' do
        it 'parsed eof' do
          expect(parsed).to be_eof
        end
      end

      context 'parsed twice' do
        before do
          parser.parse_next
        end

        it 'parsed eof' do
          expect(parsed).to be_eof
        end
      end
    end
  end
end