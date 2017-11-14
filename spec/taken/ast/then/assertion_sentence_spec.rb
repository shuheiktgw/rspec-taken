require 'spec_helper'
require 'taken/token'
require 'taken/ast/then/assertion_sentence'

RSpec.describe Taken::Ast::Unknown do
  describe 'to_r' do
    subject { Taken::Ast::Then::AssertionSentence.new(left: left, right: right).to_r }

    # stack.depth == 1
    let(:left) do
      [
        Taken::Token.new(type: Taken::Token::IDENT, literal: 'stack' ),
        Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '.' ),
        Taken::Token.new(type: Taken::Token::IDENT, literal: 'depth' )
      ]
    end

    let(:right) do
      [
        Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '1' ),
      ]
    end

    it { is_expected.to eq 'expect(stack.depth).to eq(1)' }
  end
end