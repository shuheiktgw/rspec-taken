require 'rspec/given'
require 'spec_helper'
require_relative '../given_specs/stack'

RSpec.describe Stack do
  def stack_with(initial_contents)
    stack = Stack.new
    initial_contents.each do |item| stack.push(item) end
    stack
  end

  let(:stack) { stack_with(initial_contents) }
  Invariant { stack.empty? == (stack.depth == 0) }

  context "with no items" do
    let(:initial_contents) { [] }
    it do
      expect(stack.depth).to eq(0)
      expect(stack.depth).to eq(0)
      expect(stack.depth).to eq(0)
      expect(stack.depth).to eq(0)
      expect(stack.depth).to eq(1)
      expect(stack.depth).to eq(1)
      expect(stack.depth).to eq(1)
      expect(stack.depth).to eq(1)
    end

    context "when pushing" do
      When { stack.push(:an_item) }

      it { expect(stack.depth).to eq(1) }
      it { expect(stack.top).to eq(:an_item) }
    end

    context "when popping" do
      When(:result) { stack.pop }
      it { expect(result).to eq(Failure(Stack::UnderflowError, /empty/)) }
    end
  end

  context "with one item" do
    let(:initial_contents) { [:an_item] }

    context "when popping" do
      When(:pop_result) { stack.pop }

      it { expect(pop_result).to eq(:an_item) }
      it { expect(stack.depth).to eq(0) }
    end
  end

  context "with several items" do
    let(:initial_contents) { [:second_item, :top_item] }
    Given!(:original_depth) { stack.depth }

    context "when pushing" do
      When { stack.push(:new_item) }

      it { expect(stack.top).to eq(:new_item) }
      it { expect(stack.depth).to eq(original_depth + 1) }
    end

    context "when popping" do
      When(:pop_result) { stack.pop }

      it { expect(pop_result).to eq(:top_item) }
      it { expect(stack.top).to eq(:second_item) }
      it { expect(stack.depth).to eq(original_depth - 1) }
    end
  end
end
