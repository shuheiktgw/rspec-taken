require 'spec_helper'
require 'taken/ast/given/paren_statement'

RSpec.describe Taken::Ast::Given::ParenStatement do

  describe 'to_r' do
    subject { Taken::Ast::Given::ParenStatement.new(spaces: spaces, keyword: keyword).to_r }

    context 'no spaces' do
      let(:spaces) { '' }

      context 'with symbol keyword' do
        let(:keyword) { ':keyword' }

        it { is_expected.to eq 'let(:keyword)' }
      end

      context 'with single quoted keyword' do
        let(:keyword) { "'keyword'" }

        it { is_expected.to eq "let('keyword')" }
      end

      context 'with double quoted keyword' do
        let(:keyword) { '"keyword"' }

        it { is_expected.to eq 'let("keyword")' }
      end
    end

    context 'with spaces' do
      let(:spaces) { '     ' }

      context 'with symbol keyword' do
        let(:keyword) { ':keyword' }

        it { is_expected.to eq '     let(:keyword)' }
      end

      context 'with single quoted keyword' do
        let(:keyword) { "'keyword'" }

        it { is_expected.to eq "     let('keyword')" }
      end

      context 'with double quoted keyword' do
        let(:keyword) { '"keyword"' }

        it { is_expected.to eq '     let("keyword")' }
      end
    end
  end
end