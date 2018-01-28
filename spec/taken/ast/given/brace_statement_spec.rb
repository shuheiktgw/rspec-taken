require 'spec_helper'
require 'taken/ast/given/brace_statement'

RSpec.describe Taken::Ast::Given::BraceStatement do

  describe 'to_r' do
    subject { Taken::Ast::Given::BraceStatement.new(spaces: '', block: block).to_r }

    let(:block) do
      Taken::Ast::Block.new(
        opener: opener,
        sentences: sentences,
        closer: closer
      )
    end

    let(:sentences) { [Taken::Token.new(type: Taken::Token::IDENT, literal: 'sentence')] }

    context '{} block' do
      let(:opener) { Taken::Token.new(type: Taken::Token::LBRACE, literal: '{') }
      let(:closer) { Taken::Token.new(type: Taken::Token::RBRACE, literal: '}', white_spaces: '') }


    end
  end
end