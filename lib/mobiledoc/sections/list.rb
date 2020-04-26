module Mobiledoc::Section
  class List
    attr_accessor :tag

    def initialize(texts = [], options = {})
      self.texts = texts
      self.tag = options[:tag] || :ul
    end

    def markups
      Set.new
    end

    def serialise(ordered_markups)
      serialised_lines = texts.map { |text| [[0, [], 0, text]] }

      [3, tag, serialised_lines]
    end

    private

    attr_accessor :texts
  end
end
