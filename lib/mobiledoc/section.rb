module Mobiledoc::Section
  class Text
    attr_accessor :tag

    def initialize(text = '', options = {})
      self.text = text
      self.tag = options[:tag] || :p
    end

    def serialise
      [1, tag, [[0, [], 0, text]]]
    end

    private

    attr_accessor :text
  end
  
  class List
    attr_accessor :tag

    def initialize(texts = [], options = {})
      self.texts = texts
      self.tag = options[:tag] || :ul
    end

    def serialise
      serialised_lines = texts.map { |text| [[0, [], 0, text]] }

      [3, tag, serialised_lines]
    end

    private

    attr_accessor :texts
  end

  class Card
  end
end
