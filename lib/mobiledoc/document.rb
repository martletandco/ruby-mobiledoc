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

    def markups
      # Make a super set of all markups
      sections
        .map(&:markups)
        .reduce(Set.new) { |acc, set| acc | set }
    end

    private

    def ordered_markups
      markups.to_a.sort_by { |markup| markup.tag_name }
    end

    def serialised_markups
        ordered_markups
        .map(&:serialise)
    end

    def serialised_sections
      sections.map {|section| section.serialise(ordered_markups) }
    end
  end
end
