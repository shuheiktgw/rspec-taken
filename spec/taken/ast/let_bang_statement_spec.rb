require 'spec_helper'
require 'taken/ast/let_bang_statement'
require_relative './shared/simple_statement_spec'

RSpec.describe Taken::Ast::LetBangStatement do

  describe 'to_r' do
    subject { Taken::Ast::LetBangStatement.new(spaces: spaces, keyword: keyword).to_r }

    it_behaves_like 'simple Given/When statements', 'let!'
  end
end
