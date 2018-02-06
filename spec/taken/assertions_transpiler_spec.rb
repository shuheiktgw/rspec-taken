require 'spec_helper'
require 'taken/assertion_transpiler'

RSpec.describe Taken::AssertionTranspiler do

  describe 'transpile' do
    subject { Taken::AssertionTranspiler.transpile(sentence) }

    context 'plane expect sentence' do
      let(:sentence) {' expect(1).to eq(1) '}
      it { is_expected.to eq ' expect(1).to eq(1) ' }
    end

    context 'normal == sentence' do
      let(:sentence) {' 1 == 1 '}
      it { is_expected.to eq 'expect(1).to eq(1)' }
    end

    context 'failure sentence with an error type and a message' do
      let(:sentence) {" do_something == Failure(SomeError, #{message}) "}

      context 'regex message' do
        let(:message) { '/Some error occurred!/' }
        it { is_expected.to eq "expect{ do_something }.to raise_error(SomeError, /Some error occurred!/)" }
      end

      context 'single quote message' do
        let(:message) { "'Some error occurred!'" }
        it { is_expected.to eq "expect{ do_something }.to raise_error(SomeError, 'Some error occurred!')" }
      end

      context 'double quote message' do
        let(:message) { '"Some error occurred!"' }
        it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, "Some error occurred!")' }
      end

      context 'message is a variable' do
        let(:message) { 'message' }
        it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, message)' }
      end
    end
  end
end
