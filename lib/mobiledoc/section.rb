module Mobiledoc::Section
  class Text
    attr_accessor :tag

    def initialize(text = '', options = {})
      self.text = text
      self.tag = options[:tag] || :p
    end

    def serialise
      [1, tag, [0, [], 0, text]]
    end

    private

    attr_accessor :text
  end
  
  class List
  end

  class Card
  end
end
