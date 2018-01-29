require 'spec_helper'

RSpec.shared_examples 'simple Given statements' do |prefix|
  context 'no spaces' do
    let(:spaces) { '' }

    context 'with symbol keyword' do
      let(:keyword) { ':keyword' }

      it { is_expected.to eq "#{prefix}(:keyword)" }
    end

    context 'with single quoted keyword' do
      let(:keyword) { "'keyword'" }

      it { is_expected.to eq "#{prefix}('keyword')" }
    end

    context 'with double quoted keyword' do
      let(:keyword) { '"keyword"' }

      it { is_expected.to eq "#{prefix}(\"keyword\")" }
    end
  end

  context 'with spaces' do
    let(:spaces) { '     ' }

    context 'with symbol keyword' do
      let(:keyword) { ':keyword' }

      it { is_expected.to eq "     #{prefix}(:keyword)"}
    end

    context 'with single quoted keyword' do
      let(:keyword) { "'keyword'" }

      it { is_expected.to eq "     #{prefix}('keyword')" }
    end

    context 'with double quoted keyword' do
      let(:keyword) { '"keyword"' }

      it { is_expected.to eq "     #{prefix}(\"keyword\")"}
    end
  end
end
