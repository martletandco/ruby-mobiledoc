module Mobiledoc
  class Document
    VERSION = '0.3.2'.freeze

    attr_accessor :sections

    def initialize(sections: sections = [])
      self.sections = sections
    end

    def serialise(version = VERSION)
      {
        version: VERSION,
        markups: [],
        atoms: [],
        cards: [],
        sections: serialised_sections
      }
    end

    private

    def serialised_sections
      sections.map(&:serialise) 
    end
  end
end
