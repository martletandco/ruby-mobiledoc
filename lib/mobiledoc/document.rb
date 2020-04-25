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
        markups: serialised_markups,
        atoms: [],
        cards: [],
        sections: serialised_sections
      }
    end

    private

    def serialised_markups
      # Make a super set of all markups
      sections
        .map(&:markups)
        .reduce(Set.new) { |acc, set| acc | set }
        .to_a
        .map { |markup| [markup.tag_name] }
    end

    def serialised_sections
      # @incomplete: need to capture markups (and atoms eventuall) that used by sections
      sections.map(&:serialise) 
    end
  end
end
