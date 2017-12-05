require 'spec_helper'
require 'taken/ast/block'

RSpec.describe Taken::Ast::Block do

  describe 'merge_sentences' do
    subject { block.to_r }

    let(:block) do
      Taken::Ast::Block.new(
        opener: Taken::Ast::Unknown.new(token: opener),
        sentences: sentences,
        closer: Taken::Ast::Unknown.new(token: closer)
      )
    end

    let()

    before do
      block.merge_sentences(another_sentenes)
    end

    it {is_expected.to be_eof}
  end
end