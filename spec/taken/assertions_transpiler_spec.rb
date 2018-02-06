require 'spec_helper'
require 'taken/assertion_transpiler'

RSpec.describe Taken::AssertionTranspiler do

  describe 'transpile' do
    subject { Taken::AssertionTranspiler.transpile(sentence) }

    context 'normal == sentence' do
      let(:sentence) {' 1 == 1 '}
      it { is_expected.to eq 'expect(1).to eq(1)' }
    end

    context 'failure sentence' do
      let(:sentence) {" do_something == Failure(SomeError, /#{message}/) "}

      context 'empty message' do
        let(:message) { 'empty' }
        it { is_expected.to eq "expect{ do_something }.to raise_error(SomeError)" }
      end

      context 'not empty message' do
        let(:message) { 'Some error occurred!' }
        it { is_expected.to eq "expect{ do_something }.to raise_error(SomeError, 'Some error occurred!')" }
      end
    end
  end
end
