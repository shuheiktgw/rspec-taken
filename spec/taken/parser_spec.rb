require 'spec_helper'
require 'stringio'
require 'taken/parser'
require 'taken/lexer'
require 'taken/reader'
require 'taken/token'
require 'pry'

RSpec.describe Taken::Parser do

  let(:parser) {Taken::Parser.new(lexer)}
  let(:lexer) {Taken::Lexer.new(reader)}
  let(:reader) {Taken::Reader.new(file)}

  describe '#next_token' do
    subject(:parsed) {parser.parse_next}
    let(:file) {StringIO.new(content, 'r')}

    context 'when Given is given' do
      let(:content) {"Given(#{key}) { [:second_item, :top_item] }"}

      context 'key is symnol' do
        let(:key) {':initial_contents'}

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
            expect(parsed.to_r).to eq ' {'
          end
        end
      end

      context 'key is single quoted' do
        let(:key) {"'initial_contents'"}

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
            expect(parsed.to_r).to eq ' {'
          end
        end
      end

      context 'key is double quoted' do
        let(:key) {'"initial_contents"'}

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
            expect(parsed.to_r).to eq ' {'
          end
        end
      end
    end

    context 'when Then is given' do
      context 'when block with brackets' do
        context 'single sentence' do
          context 'without newline' do
            let(:content) {'Then{ stack.depth == 0 }'}

            it 'parses then statement' do
              expect(parsed.to_r).to eq 'it{ expect( stack.depth).to eq( 0) }'
            end
          end

          context 'with newline' do
            let(:content) do
              '' 'Then{
  stack.depth == 0
}' ''
            end

            it 'parses then statement' do
              expect(parsed.to_r).to eq '' 'it{
  expect(  stack.depth).to eq( 0)
}' ''
            end
          end
        end

        context 'multiple sentence' do
          context 'one block' do
            context 'without plain sentences' do
              let(:content) do
                '' 'Then{
  stack.depth == 0
  stack.count == 0
  stack.sound == 0
}' ''
              end

              it 'parses then statement' do
                expect(parsed.to_r).to eq '' 'it{
  expect(stack.depth).to eq(0)
  expect(stack.count).to eq(0)
  expect(stack.sound).to eq(0)
}' ''
              end
            end

            context 'with plain sentences' do
              let(:content) do
                '' 'Then{
  stack.push 1
  stack.pop
  stack.depth == 0
  stack.count == 0
  stack.sound == 0
}' ''
              end

              it 'parses then statement' do
                expect(parsed.to_r).to eq '' 'it{
  stack.push 1
  stack.pop
  expect(stack.depth).to eq(0)
  expect(stack.count).to eq(0)
  expect(stack.sound).to eq(0)
}' ''
              end
            end
          end
          context 'multiple blocks' do
            context 'without plain sentences' do
              let(:content) do
                '' '  Then{ stack.depth == 0 }
  Then{ stack.depth == 0 }
  Then{ stack.depth == 0 }
' ''
              end

              it 'parses then statement' do
                expect(parser.parse_next.to_r).to eq ('  it{ expect(stack.depth).to eq(0) }')
                expect(parser.parse_next.to_r).to eq ("\n  it{ expect(stack.depth).to eq(0) }")
                expect(parser.parse_next.to_r).to eq ("\n  it{ expect(stack.depth).to eq(0) }")
              end
            end
          end
        end
      end

      context 'when block with brackets' do
        context 'multiple sentence' do
          context 'without plain sentences' do
            let(:content) do
              '' '  Then do
    stack.depth == 0
    stack.count == 0
    stack.sound == 0
  end' ''
            end

            it 'parses then statement' do
              expect(parsed.to_r).to eq '' '  it do
    expect(stack.depth).to eq(0)
    expect(stack.count).to eq(0)
    expect(stack.sound).to eq(0)
  end' ''
            end
          end

          context 'with plain sentences' do
            let(:content) do
              '' '  Then do
    stack.push 1
    stack.pop
    stack.depth == 0
    stack.count == 0
    stack.sound == 0
  end' ''
            end

            it 'parses then statement' do
              expect(parsed.to_r).to eq '' '  it do
    stack.push 1
    stack.pop
    expect(stack.depth).to eq(0)
    expect(stack.count).to eq(0)
    expect(stack.sound).to eq(0)
  end' ''
            end
          end
        end
      end
    end

    context 'when EOF is given' do
      let(:content) {''}

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