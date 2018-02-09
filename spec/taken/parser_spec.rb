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

    context 'when Given with lparen is given' do
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

    context 'when Given without lparen is given' do
      context 'when block is {}' do
        let(:content) {"Given { do_something! }"}

        it 'parses given statement' do
          expect(parsed.to_r).to eq 'before { do_something! }'
        end
      end

      context 'when block is do end' do
        let(:content) do
          '''
Given do
  do_something!(arg)
  do_something!(arg)
end'''

        end

        it 'parses given statement' do
          expect(parsed.to_r).to eq '''
before do
  do_something!(arg)
  do_something!(arg)
end'''
        end
      end
    end

    context 'when Given! is given' do
      context 'when block is {}' do
        let(:content) {"Given!(:test) { do_something! }"}

        context 'parsed once' do
          it 'parses given statement' do
            expect(parsed.to_r).to eq 'let!(:test)'
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

      context 'when block is do end' do
        let(:content) do
          '''Given!(:test) do
  do_something!
end
          '''
        end

        context 'parsed once' do
          it 'parses given statement' do
            expect(parsed.to_r).to eq 'let!(:test)'
          end
        end

        context 'parsed twice' do
          before do
            parser.parse_next
          end

          it 'parsed Unknown {' do
            expect(parsed.to_r).to eq ' do'
          end
        end
      end
    end

    context 'when When with paren is given' do
      context 'when block is {}' do
        let(:content) {"When(:test) { do_something! }"}

        context 'parsed once' do
          it 'parses given statement' do
            expect(parsed.to_r).to eq 'let!(:test)'
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

      context 'when block is do end' do
        let(:content) do
          '''When(:test) do
  do_something!
end
          '''
        end

        context 'parsed once' do
          it 'parses given statement' do
            expect(parsed.to_r).to eq 'let!(:test)'
          end
        end

        context 'parsed twice' do
          before do
            parser.parse_next
          end

          it 'parsed Unknown {' do
            expect(parsed.to_r).to eq ' do'
          end
        end
      end
    end

    context 'when When without lparen is given' do
      context 'when block is {}' do
        let(:content) {"When { do_something! }"}

        it 'parses given statement' do
          expect(parsed.to_r).to eq 'before { do_something! }'
        end
      end

      context 'when block is do end' do
        let(:content) do
          '''
When do
  do_something!(arg)
  do_something!(arg)
end'''

        end

        it 'parses given statement' do
          expect(parsed.to_r).to eq '''
before do
  do_something!(arg)
  do_something!(arg)
end'''
        end
      end
    end

    context 'when Then is given' do
      context 'when block with brackets' do
        context 'single sentence' do
          context 'without newline' do
            let(:content) {'Then{ stack.depth == 0 }'}

            it 'parses then statement' do
              expect(parsed.to_r).to eq 'it{ expect(stack.depth).to eq(0) }'
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
  expect(stack.depth).to eq(0)
}' ''
            end
          end
        end

        context 'multiple sentence' do
          context 'one block' do
            context 'without plain sentences' do
              let(:content) do
                '' 'Then{
  do_something
  stack.count == 0
  stack.sound == 0
}' ''
              end

              it 'parses then statement' do
                expect(parsed.to_r).to eq '' 'it{
  do_something
  stack.count == 0
  expect(stack.sound).to eq(0)
}' ''
              end
            end

            context 'with plain sentences' do
              let(:content) do
                '' 'Then{
  stack.push 1
  stack.pop
  stack.sound == 0
}' ''
              end

              it 'parses then statement' do
                expect(parsed.to_r).to eq '' 'it{
  stack.push 1
  stack.pop
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
    stack.depth == 0
    stack.count == 0
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

    context 'when And is given' do
      let(:content) {'And{ stack.depth == 0 }'}

      it 'raises runtime error' do
        expect{ parsed.to_r }.to raise_error RuntimeError, 'Cannot call and to_r of And Statement. Something must be wrong with the logic.'
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
