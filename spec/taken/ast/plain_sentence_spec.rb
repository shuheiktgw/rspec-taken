require 'spec_helper'
require 'taken/ast/eof'

RSpec.describe Taken::Ast::PlainSentence do
  describe 'to_r' do
    subject { Taken::Ast::PlainSentence.new(tokens).to_r }
    let(:tokens) do
      [
        Taken::Token.new(type: Taken::Token::IDENT, literal: 'stack').attach_white_spaces(" \n"),
        Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '.'),
        Taken::Token.new(type: Taken::Token::IDENT, literal: 'pop')
      ]
    end

    it { is_expected.to eq " \nstack.pop" }
  end

  describe '==' do
    subject { Taken::Ast::PlainSentence.new(tokens) == Taken::Ast::PlainSentence.new(other_tokens) }
    let(:tokens) do
      [
        Taken::Token.new(type: Taken::Token::IDENT, literal: 'stack').attach_white_spaces(" \n"),
        Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '.'),
        Taken::Token.new(type: Taken::Token::IDENT, literal: 'pop')
      ]
    end

    context 'other is the exactly same' do
      let(:other_tokens) { tokens }

      it { is_expected.to be_truthy }
    end

    context 'other is slightly different' do
      let(:other_tokens) do
        [
          Taken::Token.new(type: Taken::Token::IDENT, literal: 'stack').attach_white_spaces(" \n"),
          Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '.'),
          Taken::Token.new(type: Taken::Token::IDENT, literal: 'pop', white_spaces: ' ')
        ]
      end

      it { is_expected.to be_falsey }
    end
  end
end
