require 'spec_helper'

require 'mobiledoc'

include Mobiledoc

# Note that documents are built in a way that suits writing tests, rather than the recomended way of using this library

describe Document, 'serialise' do
  describe 'when empty' do
    subject { Document.new }

    it 'defaults to using latest supported version' do
      doc = subject.serialise

      doc[:version].must_equal '0.3.2'
    end

    it 'returns an empty document hash for version 0.3.2' do
      doc = subject.serialise '0.3.2'

      doc[:version].must_equal '0.3.2'
      doc[:markups].must_equal []
      doc[:atoms].must_equal []
      doc[:cards].must_equal []
      doc[:sections].must_equal []
    end
  end

  describe 'sections' do
    subject { Document.new }

    it 'lists sections in order' do
      subject.sections = [
        Section::Text.new('one'),
        Section::Text.new('two'),
        Section::Text.new('three')
      ]
      doc = subject.serialise

      doc[:sections].must_equal [
        [1, :p, [0, [], 0, 'one']],
        [1, :p, [0, [], 0, 'two']],
        [1, :p, [0, [], 0, 'three']]
      ]
    end

    describe 'text' do
    end

    describe 'list' do
    end

    describe 'card' do
    end
  end
end