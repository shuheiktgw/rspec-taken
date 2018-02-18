require 'spec_helper'
require 'taken/ast/eof'

RSpec.describe Taken::Ast::EOF do
  describe 'to_r' do
    subject { described_class.new }

    it { is_expected.to be_eof }
  end
end
