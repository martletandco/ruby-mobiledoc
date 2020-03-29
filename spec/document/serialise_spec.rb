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
    let(:sections) { [] }
    subject { Document.new(sections: sections).serialise }

    describe 'order' do
      let(:sections) { [
        Section::Text.new('one'),
        Section::Text.new('two'),
        Section::Text.new('three')
      ] }

      it 'lists sections' do
        doc = subject

        doc[:sections].must_equal [
          [1, :p, [0, [], 0, 'one']],
          [1, :p, [0, [], 0, 'two']],
          [1, :p, [0, [], 0, 'three']]
        ]
      end
    end

    describe 'text' do
      let(:sections) { [
        Section::Text.new('one', tag: :p),
        Section::Text.new('two', tag: :h1),
        Section::Text.new('three', tag: :h2)
      ] }

      it 'outputs the text section tags' do
        doc = subject

        doc[:sections].must_equal [
          [1, :p, [0, [], 0, 'one']],
          [1, :h1, [0, [], 0, 'two']],
          [1, :h2, [0, [], 0, 'three']]
        ]
      end
    end

    describe 'list' do
    end

    describe 'card' do
    end
  end
end