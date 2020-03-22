require 'test_helper'

require 'mobiledoc'

describe Mobiledoc::Document, 'serialise' do
  describe 'when empty' do
    subject { Mobiledoc::Document.new }

    it 'returns an empty json doc' do
      doc = subject.serialise

      doc[:version].must_equal '0.3.2'
      doc[:markups].must_equal []
      doc[:atoms].must_equal []
      doc[:cards].must_equal []
      doc[:sections].must_equal []
    end
  end
end
