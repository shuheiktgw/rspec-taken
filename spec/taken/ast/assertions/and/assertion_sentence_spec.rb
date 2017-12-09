require 'spec_helper'
require 'taken/token'
require 'taken/ast/assertions/then/assertion_sentence'

RSpec.describe Taken::Ast::Assertions::Then::AssertionSentence do
  describe 'to_r' do
    subject { Taken::Ast::Assertions::Then::AssertionSentence.new(left: left, right: right).to_r }

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
        Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '+' ).attach_white_spaces(' '),
        Taken::Token.new(type: Taken::Token::UNKNOWN, literal: '1' ).attach_white_spaces(' '),
      ]
    end

    it { is_expected.to eq 'expect(stack.depth).to eq(1 + 1)' }
  end
end