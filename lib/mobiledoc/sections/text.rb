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

    def serialise
      [1, tag, serialised_markups]
    end

    private

    attr_accessor :segments

    def serialised_markups
      # @enhance: this will be incorrect (or rather, not optimal) once the same markup
      # is in consecutive segments as it instead should be serialised as open but not
      # closed in the first segment, then closed in the last
      @segments.map do |segment|
        text = segment.first
        markups = segment.last

        marksups_to_open = []
        marksups_to_open << 0 unless markups.empty?

        # @magic: '0' is a text markup. Also it might be clearer if this was calling a
        # method to build this perhaps?
        [0, marksups_to_open, 0, text]
      end
    end
  end
end
