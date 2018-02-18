require 'spec_helper'
require 'taken/ast/given/paren_statement'
require_relative '../shared/simple_statement_spec'

RSpec.describe Taken::Ast::Given::ParenStatement do
  describe 'to_r' do
    subject { Taken::Ast::Given::ParenStatement.new(spaces: spaces, keyword: keyword).to_r }

    it_behaves_like 'simple Given/When statements', 'let'
  end
end
