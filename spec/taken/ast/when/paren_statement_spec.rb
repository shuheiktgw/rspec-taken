require 'spec_helper'
require 'taken/ast/when/paren_statement'
require_relative '../shared/simple_statement_spec'

RSpec.describe Taken::Ast::When::ParenStatement do

  describe 'to_r' do
    subject { Taken::Ast::When::ParenStatement.new(spaces: spaces, keyword: keyword).to_r }

    it_behaves_like 'simple Given/When statements', 'let!'
  end
end
