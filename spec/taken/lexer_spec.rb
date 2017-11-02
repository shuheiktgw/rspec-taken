require 'spec_helper'
require 'stringio'
require 'taken/lexer'
require 'taken/reader'
require 'taken/token'

RSpec.describe Taken::Lexer do
  let(:lexer) { Taken::Lexer.new(reader) }
  let(:reader) { Taken::Reader.new(file) }

  describe '#next_token' do
    subject(:token){ lexer.next_token }
    let(:file) { StringIO.new(content, 'r') }

    context '= is given' do
      let(:content) { '=' }

      it { expect(token.type).to eq(Taken::Token::UNKNOWN)  }
      it { expect(token.literal).to eq('=')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context '== is given' do
      let(:content) { '==' }

      it { expect(token.type).to eq(Taken::Token::EQ)  }
      it { expect(token.literal).to eq('==')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context '=== is given' do
      let(:content) { '===' }

      it { expect(token.type).to eq(Taken::Token::UNKNOWN)  }
      it { expect(token.literal).to eq('===')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context '( is given' do
      let(:content) { '(' }

      it { expect(token.type).to eq(Taken::Token::LPAREN)  }
      it { expect(token.literal).to eq('(')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context ') is given' do
      let(:content) { ')' }

      it { expect(token.type).to eq(Taken::Token::RPAREN)  }
      it { expect(token.literal).to eq(')')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context '{ is given' do
      let(:content) { '{' }

      it { expect(token.type).to eq(Taken::Token::LBRACE)  }
      it { expect(token.literal).to eq('{')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context '} is given' do
      let(:content) { '}' }

      it { expect(token.type).to eq(Taken::Token::RBRACE)  }
      it { expect(token.literal).to eq('}')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context ': is given' do
      let(:content) { ':' }

      it { expect(token.type).to eq(Taken::Token::COLON)  }
      it { expect(token.literal).to eq(':')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'EOF is given' do
      let(:content) { '' }

      it { expect(token.type).to eq(Taken::Token::EOF)  }
      it { expect(token.literal).to eq('EOF')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'do is given' do
      let(:content) { 'do' }

      it { expect(token.type).to eq(Taken::Token::DO)  }
      it { expect(token.literal).to eq('do')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'end is given' do
      let(:content) { 'end' }

      it { expect(token.type).to eq(Taken::Token::END_KEY)  }
      it { expect(token.literal).to eq('end')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'When is given' do
      let(:content) { 'When' }

      it { expect(token.type).to eq(Taken::Token::WHEN)  }
      it { expect(token.literal).to eq('When')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'Then is given' do
      let(:content) { 'Then' }

      it { expect(token.type).to eq(Taken::Token::THEN)  }
      it { expect(token.literal).to eq('Then')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'Given is given' do
      let(:content) { 'Given' }

      it { expect(token.type).to eq(Taken::Token::GIVEN)  }
      it { expect(token.literal).to eq('Given')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'Given is given' do
      let(:content) { 'Given!' }

      it { expect(token.type).to eq(Taken::Token::GIVEN_BANG)  }
      it { expect(token.literal).to eq('Given!')  }
      it { expect(token.white_spaces).to eq('')  }
    end

    context 'identifiers are given' do
      context 'normal' do
        let(:content) { 'identifier' }

        it { expect(token.type).to eq(Taken::Token::IDENT)  }
        it { expect(token.literal).to eq('identifier')  }
        it { expect(token.white_spaces).to eq('')  }
      end

      context 'with _' do
        let(:content) { '_some_identifier' }

        it { expect(token.type).to eq(Taken::Token::IDENT)  }
        it { expect(token.literal).to eq('_some_identifier')  }
        it { expect(token.white_spaces).to eq('')  }
      end

      context 'with -' do
        let(:content) { 'some-identifier' }

        it { expect(token.type).to eq(Taken::Token::IDENT)  }
        it { expect(token.literal).to eq('some-identifier')  }
        it { expect(token.white_spaces).to eq('')  }
      end

      context 'with CAPITAL LETTERS' do
        let(:content) { 'CAPITAL_LETTERS' }

        it { expect(token.type).to eq(Taken::Token::IDENT)  }
        it { expect(token.literal).to eq('CAPITAL_LETTERS')  }
        it { expect(token.white_spaces).to eq('')  }
      end
    end

    context 'white spaces are given' do
      let(:content) { " \n\t\r" }

      it { expect(token.type).to eq(Taken::Token::EOF)  }
      it { expect(token.literal).to eq('EOF')  }
      it { expect(token.white_spaces).to eq(" \n\t\r")  }
    end
  end
end