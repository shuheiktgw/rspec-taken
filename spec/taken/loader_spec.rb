require 'spec_helper'
require 'taken/loader'

RSpec.describe Taken::Loader do
  describe 'initialize' do
    context 'when file/directory exists' do
      subject { described_class.new(File.expand_path(path, __FILE__)).file_names }

      context 'when file is given' do
        let(:path) { '../../../lib/taken/spec_samples/plain_specs/plain_first_spec.rb' }

        it { is_expected.to eq [File.expand_path(path, __FILE__)] }
      end

      context 'when directory is given' do
        let(:path) { '../../../lib/taken/spec_samples/plain_specs' }

        it { expect(subject.length).to eq 3 }
        it { is_expected.to include(File.expand_path(path + '/plain_first_spec.rb', __FILE__)) }
        it { is_expected.to include(File.expand_path(path + '/plain_second_spec.rb', __FILE__)) }
        it { is_expected.not_to include(File.expand_path(path + '/plain_ruby.rb', __FILE__)) }
      end
    end

    context 'when spec file/directory does not exist' do
      subject { described_class.new(File.expand_path(path, __FILE__)) }

      context 'when directory specifies' do
        context 'when directory does not exit' do
          let(:path) { '/path/does/not/exits' }

          it 'raises Errno::ENOENT' do
            expect { subject }.to raise_error Errno::ENOENT
          end
        end

        context 'when directory does not contain _spec.rb file' do
          let(:path) { '../../../lib/taken/spec_samples/only_plain_ruby' }

          it 'raises RuntimeError' do
            expect { subject }.to raise_error RuntimeError, 'The given path does not contain _spec.rb file.'
          end
        end
      end

      context 'when file specifies' do
        context 'when file does not exit' do
          let(:path) { '../../../lib/taken/spec_samples/not_exited_spec.rb' }

          it 'raises Errno::ENOENT' do
            expect { subject }.to raise_error Errno::ENOENT
          end
        end

        context 'when file is not _spec.rb file' do
          let(:path) { '../../../lib/taken/spec_samples/only_plain_ruby/plain_ruby.rb' }

          it 'raises RuntimeError' do
            expect { subject }.to raise_error RuntimeError, 'The file does not end with _spec.rb.'
          end
        end
      end
    end
  end

  describe '#load_next_file' do
    let(:loader) { described_class.new(path) }
    let(:path) { File.expand_path('../../../lib/taken/spec_samples/plain_specs/plain_first_spec.rb', __FILE__) }

    context 'within range' do
      subject do
        loader.load_next_file
      end

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'out of range' do
      subject do
        loader.load_next_file
        loader.load_next_file
      end

      it 'returns false' do
        is_expected.to be_falsy
      end
    end
  end
end
