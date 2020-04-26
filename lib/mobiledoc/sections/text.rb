module Mobiledoc::Section
  class Text
    attr_accessor :tag

    def initialize(text = nil, options = {})
      @segments = []
      append(text)

      @tag = options[:tag] || :p
    end

    def append(text, markups = [])
      segments << [text, markups] unless text.nil?
    end

    def markups
      Set.new segments.map { |segment| segment.last }.flatten
    end

    def serialise(ordered_markups)
      [1, tag, serialised_markups(ordered_markups)]
    end

    private

    attr_accessor :segments

    def serialised_markups(ordered_markups)
      # @enhance: this will be incorrect (or rather, not optimal) once the same markup
      # is in consecutive segments as it instead should be serialised as open but not
      # closed in the first segment, then closed in the last
      @segments.map do |segment|
        text = segment.first
        markups = segment.last

        marksups_to_open = markups.map { |markup| ordered_markups.index(markup) }

        number_markups_closed = marksups_to_open.length

        # @magic: '0' is a text markup. Also it might be clearer if this was calling a
        # method to build this perhaps?
        [0, marksups_to_open, number_markups_closed, text]
      end
    end
  end
end
