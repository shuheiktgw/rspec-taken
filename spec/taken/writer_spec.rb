require 'spec_helper'
require 'taken/writer'

RSpec.describe Taken::Writer do
  describe 'initialize' do
    subject { described_class.new(file_path: path, overwrite: false) }

    context 'when file name with "spec" is given' do
      let(:path) { File.expand_path('../../../lib/taken/spec_samples/test_outputs/test_spec.rb', __FILE__) }

      it 'does not raise Error' do
        expect { subject }.not_to raise_error
      end

      it 'sets file object' do
        expect(subject.file).not_to be_nil
      end
    end

    context 'when file name without "spec" is given' do
      let(:path) { File.expand_path('../../../lib/taken/spec_samples/test_outputs/test.rb', __FILE__) }

      it 'raises RuntimeError' do
        expect { subject }.to raise_error RuntimeError, "File should end with _spec.rb. file_path: #{path}"
      end
    end
  end

  describe '#write' do
    let(:writer) { described_class.new(file_path: path, overwrite: false) }
    let(:path) { File.expand_path('../../../lib/taken/spec_samples/test_outputs/test_spec.rb', __FILE__) }
    let(:content) { 'this is a test sentence.' }

    before do
      writer.write(content)
      writer.close
    end

    it 'writes' do
      expect(File.read(path)).to eq "this is a test sentence.\n"
    end
  end
end
