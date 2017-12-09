require 'spec_helper'
require 'taken/token'
require 'taken/ast/assertions/and/statement'

RSpec.describe Taken::Ast::Assertions::And::Statement do
  describe 'merged_sentences' do
    subject { Taken::Ast::Assertions::And::Statement.new(spaces: '', block: block).merged_sentences }

    let(:block) do
      Taken::Ast::Block.new(
        opener: Taken::Token.new(type: Taken::Token::LBRACE, literal: '{'),
        sentences: sentences,
        closer: Taken::Token.new(type: Taken::Token::RBRACE, literal: '}')
      )
    end

    let(:sentences) { [sentence] }
    let(:sentence) { Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'original', white_spaces: '')]) }

    it { is_expected.to eq sentences }
  end
end