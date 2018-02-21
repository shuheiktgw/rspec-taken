require 'spec_helper'
require 'stringio'
require 'taken/loader'
require 'taken/reader'
require 'taken/lexer'
require 'taken/parser'
require 'taken/writer'
require 'taken/generator'

RSpec.describe Taken::Generator do
  subject { destination.string }

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

  context 'test' do
    let(:content) { 'test' }
    let(:expected) { 'test' }

    it { is_expected.to eq expected }
  end
end
