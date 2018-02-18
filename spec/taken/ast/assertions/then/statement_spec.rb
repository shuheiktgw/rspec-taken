require 'spec_helper'
require 'taken/token'
require 'taken/ast/assertions/then/statement'
require 'taken/ast/assertions/and/statement'

RSpec.describe Taken::Ast::Assertions::Then::Statement do
  describe '#merge_and!' do
    subject { then_statement.merge_and!(and_statement).to_r }

    let(:then_statement) { described_class.new(spaces: '', block: then_block) }

    let(:then_block) do
      Taken::Ast::Block.new(
        opener: Taken::Token.new(type: Taken::Token::LBRACE, literal: '{'),
        sentences: then_sentences,
        closer: Taken::Token.new(type: Taken::Token::RBRACE, literal: '}')
      )
    end

    let(:then_sentences) { [then_sentence] }
    let(:then_sentence) { Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'then sentence', white_spaces: '')]) }

    let(:and_statement) { Taken::Ast::Assertions::And::Statement.new(spaces: '', block: and_block) }

    let(:and_block) do
      Taken::Ast::Block.new(
        opener: Taken::Token.new(type: Taken::Token::LBRACE, literal: '{'),
        sentences: and_sentences,
        closer: Taken::Token.new(type: Taken::Token::RBRACE, literal: '}')
      )
    end

    let(:and_sentences) { [and_sentence] }
    let(:and_sentence) { Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'and sentence', white_spaces: '')]) }

    it { is_expected.to eq "it do\nthen sentence\nand sentence\nend" }
  end
end
