require 'spec_helper'
require 'taken'

RSpec.describe Rspec::Taken do
  describe '#execute' do
    subject { Taken.taken(file_path) }
    let(:file_path) { File.expand_path(path, __FILE__) }

    context 'plain ruby file is specified' do
      let(:path) { '../../../lib/taken/spec_samples/plain_specs/plain_second_spec.rb' }

      it { expect{ subject }.not_to raise_error }
    end

    context 'stack given file is specified' do
      let(:path) { '../../../lib/taken/spec_samples/given_specs/stack_spec.rb' }

      it { expect{ subject }.not_to raise_error }
    end
  end
end
