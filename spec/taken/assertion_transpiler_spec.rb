require 'spec_helper'
require 'taken/assertion_transpiler'

RSpec.describe Taken::AssertionTranspiler do
  describe 'transpile' do
    subject { described_class.transpile(sentence) }

    context 'plane expect sentence' do
      let(:sentence) { ' expect(1).to eq(1) ' }

      it { is_expected.to eq ' expect(1).to eq(1) ' }
    end

    context 'normal == sentence' do
      context 'without parenthesis' do
        let(:sentence) { ' 1 == 1 ' }

        it { is_expected.to eq 'expect(1).to eq(1)' }
      end

      context 'with parenthesis' do
        let(:sentence) { ' 1 == (1 + (1 + (1)) - 2) ' }

        it { is_expected.to eq 'expect(1).to eq(1 + (1 + (1)) - 2)' }
      end
    end

    context 'failure sentence with an error type and a message' do
      context 'with parenthesis' do
        let(:sentence) { " do_something == Failure( SomeError, #{message}) " }

        context 'regex message' do
          let(:message) { '/Some error occurred! (test!)/' }

          it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, /Some error occurred! (test!)/)' }
        end

        context 'single quote message' do
          let(:message) { "'Some error occurred! (test!)'" }

          it { is_expected.to eq "expect{ do_something }.to raise_error(SomeError, 'Some error occurred! (test!)')" }
        end

        context 'double quote message' do
          let(:message) { '"Some error occurred! (test!)"' }

          it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, "Some error occurred! (test!)")' }
        end

        context 'message is a variable' do
          let(:message) { 'message(test!)' }

          it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, message(test!))' }
        end
      end

      context 'without parenthesis' do
        let(:sentence) { " do_something == Failure SomeError, #{message} " }

        context 'regex message' do
          let(:message) { '/Some error occurred! (test!)/' }

          it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, /Some error occurred! (test!)/)' }
        end

        context 'single quote message' do
          let(:message) { "'Some error occurred! (test!)'" }

          it { is_expected.to eq "expect{ do_something }.to raise_error(SomeError, 'Some error occurred! (test!)')" }
        end

        context 'double quote message' do
          let(:message) { '"Some error occurred! (test!)"' }

          it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, "Some error occurred! (test!)")' }
        end

        context 'message is a variable' do
          let(:message) { 'message(test!)' }

          it { is_expected.to eq 'expect{ do_something }.to raise_error(SomeError, message(test!))' }
        end
      end
    end
    context 'end_with ?' do
      context 'valid?' do
        let(:sentence) { ' some_model.valid? ' }

        it { is_expected.to eq 'expect(some_model).to be_valid' }
      end

      context 'empty?' do
        let(:sentence) { ' [1, 2, 3, 4].empty? ' }

        it { is_expected.to eq 'expect([1, 2, 3, 4]).to be_empty' }
      end

      context 'nil?' do
        let(:sentence) { ' (nil + nil + nil + nil).nil? ' }

        it { is_expected.to eq 'expect(nil + nil + nil + nil).to be_nil' }
      end

      context 'include?' do
        let(:sentence) { ' [1, 2, 3, 4, 5].include?(1) ' }

        it { is_expected.not_to eq 'expect([1, 2, 3, 4, 5]).to include?(1)' }
      end
    end
    context '== false' do
      let(:sentence) { ' false == false ' }

      it { is_expected.to eq 'expect(false).to be_falsey' }
    end
    context '!=' do
      let(:sentence) { ' false != true ' }

      it { is_expected.to eq 'expect(false).not_to eq(true)' }
    end
    context 'more than two ==s' do
      let(:sentence) { ' 1 == [1, 2, 3].select{|e| e == 1 } ' }

      it { is_expected.to eq 'expect(1 == [1, 2, 3].select{|e| e == 1 }).to be_truthy' }
    end
    # This should have been handled, but so far there is no good ways to do so...
    context 'incomplete sentence' do
      let(:sentence) { ' }.by(-1) ' }

      it { is_expected.to eq ' }.by(-1) ' }
    end
  end
end
