require 'spec_helper'
require 'stringio'
require 'taken/lexer'
require 'taken/reader'
require 'taken/token'

RSpec.describe Taken::Lexer do
  RSpec.shared_examples 'assert lexing' do |token_type, literal, spaces|
    it { expect(token.type).to eq(token_type)  }
    it { expect(token.literal).to eq(literal)  }
    it { expect(token.white_spaces).to eq(spaces)  }
  end

  let(:lexer) { Taken::Lexer.new(reader) }
  let(:reader) { Taken::Reader.new(file) }

  describe '#next_token' do
    subject(:token){ lexer.next_token }
    let(:file) { StringIO.new(content, 'r') }

    context '= is given' do
      let(:content) { '=' }

      it_behaves_like 'assert lexing', Taken::Token::UNKNOWN, '=', ''
    end

    context '== is given' do
      let(:content) { '==' }

      it_behaves_like 'assert lexing', Taken::Token::EQ, '==', ''
    end

    context '=== is given' do
      let(:content) { '===' }

      it_behaves_like 'assert lexing', Taken::Token::UNKNOWN, '===', ''
    end

    context '( is given' do
      let(:content) { '(' }

      it_behaves_like 'assert lexing', Taken::Token::LPAREN, '(', ''
    end

    context ') is given' do
      let(:content) { ')' }

      it_behaves_like 'assert lexing', Taken::Token::RPAREN, ')', ''
    end

    context '{ is given' do
      let(:content) { '{' }

      it_behaves_like 'assert lexing', Taken::Token::LBRACE, '{', ''
    end

    context '} is given' do
      let(:content) { '}' }

      it_behaves_like 'assert lexing', Taken::Token::RBRACE, '}', ''
    end

    context ': is given' do
      let(:content) { ':' }

      it_behaves_like 'assert lexing', Taken::Token::COLON, ':', ''
    end

    context 'EOF is given' do
      let(:content) { '' }

      it_behaves_like 'assert lexing', Taken::Token::EOF, 'EOF', ''
    end

    context 'do is given' do
      let(:content) { 'do' }

      it_behaves_like 'assert lexing', Taken::Token::DO, 'do', ''
    end

    context 'end is given' do
      let(:content) { 'end' }

      it_behaves_like 'assert lexing', Taken::Token::END_KEY, 'end', ''
    end

    context 'When is given' do
      let(:content) { 'When' }

      it_behaves_like 'assert lexing', Taken::Token::WHEN, 'When', ''
    end

    context 'Then is given' do
      let(:content) { 'Then' }

      it_behaves_like 'assert lexing', Taken::Token::THEN, 'Then', ''
    end

    context 'Given is given' do
      let(:content) { 'Given' }

      it_behaves_like 'assert lexing', Taken::Token::GIVEN, 'Given', ''
    end

    context 'Given is given' do
      let(:content) { 'Given!' }

      it_behaves_like 'assert lexing', Taken::Token::GIVEN_BANG, 'Given!', ''
    end

    context 'identifiers are given' do
      context 'normal' do
        let(:content) { 'identifier' }

        it_behaves_like 'assert lexing', Taken::Token::IDENT, 'identifier', ''
      end

      context 'with _' do
        let(:content) { '_some_identifier' }

        it_behaves_like 'assert lexing', Taken::Token::IDENT, '_some_identifier', ''
      end

      context 'with -' do
        let(:content) { 'some-identifier' }

        it_behaves_like 'assert lexing', Taken::Token::IDENT, 'some-identifier', ''
      end

      context 'with CAPITAL LETTERS' do
        let(:content) { 'CAPITAL_LETTERS' }

        it_behaves_like 'assert lexing', Taken::Token::IDENT, 'CAPITAL_LETTERS', ''
      end
    end

    context 'white spaces are given' do
      let(:content) { " \n\t\r" }

      it_behaves_like 'assert lexing', Taken::Token::EOF, 'EOF', " \n\t\r"
    end
  end
end