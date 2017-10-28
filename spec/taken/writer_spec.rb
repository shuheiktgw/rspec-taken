require 'spec_helper'
require 'taken/loader'

RSpec.describe Taken::Loader do
  describe 'initialize' do
    context 'when file/directory exists' do
      subject { Taken::Loader.new(File.expand_path(path, __FILE__)).file_names }

      context 'when file is given' do
        let(:path) { '../spec_samples/plain_specs/plain_first_spec.rb' }
        it { is_expected.to eq [ File.expand_path(path, __FILE__) ] }
      end

      context 'when directory is given' do
        let(:path) { '../spec_samples/plain_specs' }
        it { expect(subject.length).to eq 3 }
        it { is_expected.to include(File.expand_path(path + '/plain_first_spec.rb', __FILE__)) }
        it { is_expected.to include(File.expand_path(path + '/plain_second_spec.rb', __FILE__)) }
        it { is_expected.not_to include(File.expand_path(path + '/plain_ruby.rb', __FILE__)) }
      end
    end

    context 'when spec file/directory does not exist' do
      subject { Taken::Loader.new(File.expand_path(path, __FILE__)) }

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

  describe '#load_next_file' do
    let(:loader) { Taken::Loader.new(path) }
    let(:path) { File.expand_path('../spec_samples/plain_specs/plain_first_spec.rb', __FILE__) }

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

  describe '#readchar' do
    let(:loader) { Taken::Loader.new(path) }
    let(:path) { File.expand_path('../spec_samples/plain_specs/plain_third_spec.rb', __FILE__) }

    it 'reads char' do
      loader.load_next_file
      expect(loader.readchar).to eq 'a'
      expect(loader.readchar).to eq 'b'
      expect(loader.readchar).to eq 'c'
      expect(loader.readchar).to eq 'd'
      expect(loader.readchar).to eq 'e'
      expect{ loader.readchar }.to raise_error EOFError
      expect(loader.file.closed?).to be_truthy
    end
  end
end