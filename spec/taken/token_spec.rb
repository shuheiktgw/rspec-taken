require 'spec_helper'
require 'taken/token'

RSpec.describe Taken::Token do
  describe '#block_closer?' do
    subject { token.block_closer?(closer) }

    context 'when lbrace is given' do
      let(:token) { Taken::Token.new(type: Taken::Token::LBRACE, literal: '{') }

      context 'when rbrace is given' do
        let(:closer) { Taken::Token.new(type: Taken::Token::RBRACE, literal: '}') }

        it { is_expected.to be_truthy }
      end

      context 'when rbrace is not given' do
        let(:closer) { Taken::Token.new(type: Taken::Token::END_KEY, literal: 'end') }

        it { is_expected.to be_falsey }
      end
    end

    context 'when do is given' do
      let(:token) { Taken::Token.new(type: Taken::Token::DO, literal: 'do') }

      context 'when end is given' do
        let(:closer) { Taken::Token.new(type: Taken::Token::END_KEY, literal: 'end') }

        it { is_expected.to be_truthy }
      end

      context 'when end is not given' do
        let(:closer) { Taken::Token.new(type: Taken::Token::RPAREN, literal: ')') }

        it { is_expected.to be_falsey }
      end
    end

    context 'when lparen is given' do
      let(:token) { Taken::Token.new(type: Taken::Token::LPAREN, literal: '(') }

      context 'when rparen is given' do
        let(:closer) { Taken::Token.new(type: Taken::Token::RPAREN, literal: ')') }

        it { expect{ subject }.to raise_error RuntimeError, 'Unknown block opener is specified: (' }
      end

      context 'when rparen is not given' do
        let(:closer) { Taken::Token.new(type: Taken::Token::END_KEY, literal: 'end') }

        it { expect{ subject }.to raise_error RuntimeError, 'Unknown block opener is specified: (' }
      end
    end
  end
end