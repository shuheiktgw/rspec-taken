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
  end
end