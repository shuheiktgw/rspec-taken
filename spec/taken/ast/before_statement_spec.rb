require 'spec_helper'
require 'taken/ast/before_statement'

RSpec.describe Taken::Ast::BeforeStatement do
  describe 'to_r' do
    subject { described_class.new(spaces: ' ', block: block).to_r }

    let(:block) do
      Taken::Ast::Block.new(
        opener: opener,
        sentences: sentences,
        closer: closer
      )
    end

    context '{} block' do
      let(:sentences) { [Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'sentence')])] }
      let(:opener) { Taken::Token.new(type: Taken::Token::LBRACE, literal: '{') }
      let(:closer) { Taken::Token.new(type: Taken::Token::RBRACE, literal: '}', white_spaces: '') }

      it { is_expected.to eq ' before{sentence}' }
    end

    context 'do end block' do
      let(:sentences) { [Taken::Ast::PlainSentence.new([Taken::Token.new(type: Taken::Token::IDENT, literal: 'sentence', white_spaces: "\n")])] }
      let(:opener) { Taken::Token.new(type: Taken::Token::DO, literal: 'do', white_spaces: ' ') }
      let(:closer) { Taken::Token.new(type: Taken::Token::END_KEY, literal: 'end', white_spaces: "\n") }

      it { is_expected.to eq " before do\nsentence\nend" }
    end
  end
end
