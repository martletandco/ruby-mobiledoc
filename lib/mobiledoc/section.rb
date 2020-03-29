module Mobiledoc::Section
  class Text
    def initialize(text = '')
      self.text = text
    end

    def serialise
      [1, :p, [0, [], 0, text]]
    end

    private

    attr_accessor :text
  end
  
  class List
  end

  class Card
  end
end
