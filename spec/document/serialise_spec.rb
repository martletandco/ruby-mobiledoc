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
          [1, :p, [[0, [], 0, 'one']]],
          [1, :p, [[0, [], 0, 'two']]],
          [1, :p, [[0, [], 0, 'three']]]
        ]
        doc[:markups].must_equal []
        doc[:atoms].must_equal []
        doc[:cards].must_equal []
      end
    end

    describe 'text' do
      let(:sections) { [
        Section::Text.new,
        Section::Text.new('one', tag: :p),
        Section::Text.new('two', tag: :h1),
        Section::Text.new('three', tag: :h2)
      ] }

      it 'outputs the text section tags' do
        doc = subject

        doc[:sections].must_equal [
          [1, :p, []],
          [1, :p, [[0, [], 0, 'one']]],
          [1, :h1, [[0, [], 0, 'two']]],
          [1, :h2, [[0, [], 0, 'three']]]
        ]
        doc[:markups].must_equal []
        doc[:atoms].must_equal []
        doc[:cards].must_equal []
      end
    end

    describe 'image' do
      # @todo
    end

    describe 'list' do
      let(:sections) { [
        Section::List.new,
        Section::List.new(['zero'], tag: :ul),
        Section::List.new(['one', 'two'], tag: :ul),
        Section::List.new(['three'], tag: :ol)
      ] }

      it 'outputs the list section tags' do
        doc = subject

        doc[:sections].must_equal [
          [3, :ul, []],
          [3, :ul, [[[0, [], 0, 'zero']]]],
          [3, :ul, [[[0, [], 0, 'one']], [[0, [], 0, 'two']]]],
          [3, :ol, [[[0, [], 0, 'three']]]]
        ]
        doc[:markups].must_equal []
        doc[:atoms].must_equal []
        doc[:cards].must_equal []
      end
    end

    describe 'card' do
      # @todo
    end
  end

  describe 'markups' do
    describe 'in text section' do
      let(:segments_one) { [] }
      let(:section_one) do
        Section::Text.new.tap do |s|
          segments_one.each { |segment| s.append(*segment) }
        end
      end
      subject { Document.new(sections: [section_one]).serialise }

      describe 'with no options' do
        let(:segments_one) { [['Name in bold', [Markup::Bold]]] }

        it 'wraps text' do
          doc = subject
          doc[:markups].must_equal [['b']]
          doc[:sections][0][2].must_equal [
            [0, [0], 1, 'Name in bold']
          ]
          doc[:atoms].must_equal []
          doc[:cards].must_equal []
        end
      end

      describe 'with options' do
        let(:segments_one) { [['Name in link', [Markup::Anchor.new('https://tok.yo')]]] }

        it 'wraps text' do
          doc = subject
          doc[:markups].must_equal [['a', 'https://tok.yo']]
          doc[:sections][0][2].must_equal [
            [0, [0], 1, 'Name in link']
          ]
          doc[:atoms].must_equal []
          doc[:cards].must_equal []
        end
      end

      describe 'multiple' do
        describe 'not nested' do
          let(:segments_one) { [
            ['underline', [Markup::Underline]],
            [' '],
            ['bold', [Markup::Bold]],
            [' '],
            ['underline again', [Markup::Underline]]
          ]}

          it 'referres to the correct index' do
            doc = subject
            doc[:markups].must_equal [
              ['b'],
              ['u']
            ]
            doc[:sections][0][2].must_equal [
              [0, [1], 1, 'underline'],
              [0, [], 0, ' '],
              [0, [0], 1, 'bold'],
              [0, [], 0, ' '],
              [0, [1], 1, 'underline again']
            ]
            doc[:atoms].must_equal []
            doc[:cards].must_equal []
          end
        end
      end
    end
  end
end
