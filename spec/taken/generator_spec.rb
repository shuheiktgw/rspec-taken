require 'spec_helper'
require 'stringio'
require 'taken/loader'
require 'taken/reader'
require 'taken/lexer'
require 'taken/parser'
require 'taken/writer'
require 'taken/generator'

RSpec.describe Taken::Generator do
  subject do
    # Manually run a formatter since file path is mocked
    f = Rufo::Formatter.new(destination.string)
    f.format
    f.result
  end

  let(:path) { 'test_spec.rb' }
  let(:loader) { Taken::Loader.new(path).tap(&:load_next_file) }
  let(:reader) { Taken::Reader.new(loader.file) }
  let(:lexer) { Taken::Lexer.new(reader) }
  let(:parser) { Taken::Parser.new(lexer) }
  let(:writer) { Taken::Writer.new(file_path: loader.current_file_name, overwrite: true) }
  let(:generator) { described_class.new(parser, writer) }
  let(:destination) { ::StringIO.new('', 'w') }

  before do
    # Stub read
    allow(::File).to receive(:open).with(path, 'r') { StringIO.new content }
    allow(::File).to receive(:ftype).with(path).and_return('file')
    # Stub write
    allow(::File).to receive(:open).with(path, 'w') { destination }
    generator.execute
  end

  context 'plain text' do
    let(:content) { 'test test test' }
    let(:expected) { "test test test\n" }

    it { is_expected.to eq expected }
  end

  context 'Then with string opener' do
    let(:content) { 'Then { user.full_name == "#{first_name} #{last_name}" }' }
    let(:expected) { "it { expect(user.full_name).to eq(\"\#{first_name} \#{last_name}\") }\n" }

    it { is_expected.to eq expected }
  end

  context 'Then with block' do
    let(:content) do
      '''
Then do
  doing do
    execute_method!
  end
  user.full_name == "#{first_name} #{last_name}"
end
'''
    end

    let(:expected) do
      '''
it do
  doing do
    execute_method!
  end
  expect(user.full_name).to eq("#{first_name} #{last_name}")
end
'''
    end

    it { is_expected.to eq expected }
  end

  context 'Then with more than two ==s' do
    let(:content) { 'Then { 1 == [1, 2, 3].select{|e| e == 1 } }' }
    let(:expected) { "it { expect(1 == [1, 2, 3].select { |e| e == 1 }).to be_truthy }\n" }

    it { is_expected.to eq expected }
  end

  context 'Then/And with string opener' do
    let(:content) do
      '
Then { user.first_name == first_name }
And  { user.last_name == last_name }
And  { user.full_name == "#{first_name} #{last_name}" }
'
    end
    let(:expected) do
      '
it do
  expect(user.first_name).to eq(first_name)
  expect(user.last_name).to eq(last_name)
  expect(user.full_name).to eq("#{first_name} #{last_name}")
end
'
    end

    it { is_expected.to eq expected }
  end

  context 'Then/And with context' do
    let(:content) do
      "
    context 'when something' do
      Then { response.status == 200 }
      And { something.present? }
      And { something.something.blank? }
      And { something == something }
    end
"
    end

    let(:expected) do
      "
context 'when something' do
  it do
    expect(response.status).to eq(200)
    expect(something).to be_present?
    expect(something.something).to be_blank?
    expect(something).to eq(something)
  end
end
"
    end

    it { is_expected.to eq expected }
  end

  context 'Then with newline' do
    let(:content) do
      '
      Then {
        do_something!
        response.status == 200
      }
'
    end

    let(:expected) do
      '
it {
  do_something!
  expect(response.status).to eq(200)
}
'
    end

    it { is_expected.to eq expected }
  end
end
