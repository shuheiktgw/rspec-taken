require 'spec_helper'

describe Taken::Loader do
  describe '#load_next' do
    subject { Loader.new(File.expand_path(path, __FILE__)) }
    # context 'when file/directory exists' do
    #   let(:loader) {Loader.new(path)}
    #
    #   context 'when path is file' do
    #     let(:path) {File.expand_path('../jack_codes/test.jack', __FILE__)}
    #
    #     context 'call load_next once' do
    #       subject do
    #         loader.load_next
    #         loader.content
    #       end
    #
    #       it 'should return file content' do
    #         is_expected.to eq "test\ntest\ntest"
    #       end
    #     end
    #
    #     context 'call load_next twice' do
    #       subject do
    #         loader.load_next
    #         loader.load_next
    #         loader.content
    #       end
    #
    #       it 'should return nil' do
    #         is_expected.to be_nil
    #       end
    #     end
    #   end
    #
    #   context 'when path is directory' do
    #     let(:path) {File.expand_path('../jack_codes/test', __FILE__)}
    #
    #     context 'call load_next once' do
    #       subject do
    #         loader.load_next
    #         loader.content
    #       end
    #
    #
    #       it 'should return first file content' do
    #         is_expected.to eq "test1\ntest1\ntest1"
    #       end
    #     end
    #
    #     context 'call load_next twice' do
    #       subject do
    #         loader.load_next
    #         loader.load_next
    #         loader.content
    #       end
    #
    #       it 'should return second file content' do
    #         is_expected.to eq "test2\ntest2\ntest2"
    #       end
    #     end
    #
    #     context 'call load_next three times' do
    #       subject do
    #         loader.load_next
    #         loader.load_next
    #         loader.load_next
    #         loader.content
    #       end
    #
    #       it 'should return nil' do
    #         is_expected.to be_nil
    #       end
    #     end
    #   end
    # end

    context 'when file/directory does not exist' do
      context 'when directory specifies' do
        context 'when directory does not exit' do
          let(:path) { '/path/does/not/exits' }

          it 'should raise error' do
            expect { subject }.not_to raise_error
          end
        end

        context 'when directory does not contain _spec.rb file' do

        end
      end

      context 'when file specifies' do
        context 'when file does not exit' do

        end

        context 'when file is not _spec.rb file' do

        end
      end
    end
  end
end