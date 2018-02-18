require 'spec_helper'
require 'taken/ast/unknown'
require 'taken/token'

RSpec.describe Taken::Ast::Unknown do
  describe 'to_r' do
    subject { described_class.new(token: token).to_r }

    let(:token) { Taken::Token.new(type: Taken::Token::IDENT, literal: 'test') }

    it { is_expected.to eq 'test' }
  end
end
