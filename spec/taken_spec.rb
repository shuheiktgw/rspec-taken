require 'spec_helper'
require 'taken'

RSpec.describe Taken do
  describe '#execute' do
    before do
      Taken.taken(file_path)
    end

    let(:file_path) { File.expand_path(path, __FILE__) }

    context 'plain ruby file is specified' do
      let(:path) { '../taken/spec_samples/plain_specs/plain_third_spec.rb' }
      it {}
    end
  end
end
