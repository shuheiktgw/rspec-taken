require 'spec_helper'
require 'taken/ast/block'

RSpec.describe Taken::Ast::Block do

  describe 'merge_sentences' do
    subject { block.to_r }

    let(:block) do
      Taken::Ast::Block.new(
        opener: opener,
        sentences: original_sentences,
        closer: closer
      )
    end

    let(:original_sentences) { [original_sentence] }
    let(:original_sentence) { Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'original', white_spaces: original_sentence_space)]) }

    let(:another_sentences) { [another_sentence] }
    let(:another_sentence) { Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'another', white_spaces: another_sentence_space)]) }

    before do
      block.merge_sentences(another_sentences)
    end

    context '{} block' do
      let(:opener) { Taken::Token.new(type: Taken::Token::LBRACE, literal: '{') }
      let(:closer) { Taken::Token.new(type: Taken::Token::RBRACE, literal: '}', white_spaces: closer_space) }

      context 'block with newline' do
        let(:closer_space) { "\n" }

        context 'original sentence with newline' do
          let(:original_sentence_space) { "\n" }

          context 'another sentence with newline' do
            let(:another_sentence_space) { "\n" }

            it 'multiplies {} into do end' do
              expect(subject).to eq "do\noriginal\nanother\nend"
            end
          end

          context 'another sentence without newline' do
            let(:another_sentence_space) { '' }

            it 'multiplies {} into do end and add newline at the head of another sentence' do
              expect(subject).to eq "do\noriginal\nanother\nend"
            end
          end
        end
      end

      context 'block without newline' do
        let(:closer_space) { '' }

      end
    end

    context 'do end block' do

    end
  end
end