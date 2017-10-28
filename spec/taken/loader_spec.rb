require 'spec_helper'
require 'taken/loader'

RSpec.describe Taken::Loader do
  describe 'initialize' do
    subject { Taken::Loader.new(File.expand_path(path, __FILE__)) }

    context 'when file/directory does not exist' do
      context 'when directory specifies' do
        context 'when directory does not exit' do
          let(:path) { '/path/does/not/exits' }

          it 'should raise Errno::ENOENT' do
            expect { subject }.to raise_error Errno::ENOENT
          end
        end

        context 'when directory does not contain _spec.rb file' do
          let(:path) { '../spec_samples/only_plain_ruby' }

          it 'should raise RuntimeError' do
            expect { subject }.to raise_error RuntimeError, 'The given path does not contain _spec.rb file.'
          end
        end
      end

      context 'when file specifies' do
        context 'when file does not exit' do
          let(:path) { '../spec_samples/not_exited_spec.rb' }

          it 'should raise Errno::ENOENT' do
            expect { subject }.to raise_error Errno::ENOENT
          end
        end

        context 'when file is not _spec.rb file' do
          let(:path) { '../spec_samples/only_plain_ruby/plain_ruby.rb' }

          it 'should raise RuntimeError' do
            expect { subject }.to raise_error RuntimeError, 'The file does not end with _spec.rb.'
          end
        end
      end
    end
  end

  describe '#load_next' do
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
  end
end