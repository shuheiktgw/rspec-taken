require 'spec_helper'
require 'taken/ast/given/bang_statement'
require_relative '../shared/simple_statement_spec'

RSpec.describe Taken::Ast::Given::BangStatement do

  describe 'to_r' do
    subject { Taken::Ast::Given::BangStatement.new(spaces: spaces, keyword: keyword).to_r }

    it_behaves_like 'simple Given/When statements', 'let!'
  end
end
