require 'rspec/given'
require 'spec_helper'
require_relative '../given_specs/stack'

RSpec.describe Stack do
  def stack_with(initial_contents)
    stack = Stack.new
    initial_contents.each do |item| stack.push(item) end
    stack
  end

  Given(:stack) { stack_with(initial_contents) }
  Invariant { stack.empty? == (stack.depth == 0) }

  context "with no items" do
    Given(:initial_contents) { [] }
    Then {
      stack.depth == 0
      stack.depth == 0
      stack.depth == 0
      stack.depth == 0
    }

    context "when pushing" do
      When { stack.push(:an_item) }

      Then { stack.depth == 1 }
      Then { stack.top == :an_item }
end

context "when popping" do
When(:result) { stack.pop }
Then { result == Failure(Stack::UnderflowError, /empty/) }
    end
  end

  context "with one item" do
    Given(:initial_contents) { [:an_item] }

    context "when popping" do
      When(:pop_result) { stack.pop }

      Then { pop_result == :an_item }
      Then { stack.depth == 0 }
    end
  end

  context "with several items" do
    Given(:initial_contents) { [:second_item, :top_item] }
    Given!(:original_depth) { stack.depth }

    context "when pushing" do
      When { stack.push(:new_item) }

      Then { stack.top == :new_item }
      Then { stack.depth == original_depth + 1 }
    end

    context "when popping" do
      When(:pop_result) { stack.pop }

      Then { pop_result == :top_item }
      Then { stack.top == :second_item }
      Then { stack.depth == original_depth - 1 }
    end
  end
end