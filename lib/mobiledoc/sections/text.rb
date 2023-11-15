module Mobiledoc::Section
  class Text
    attr_accessor :tag

    def initialize(text = nil, options = {})
      @segments = []
      append(text)

      @tag = options[:tag] || :p
    end

    # Append adds text with optional markups to the end of the section. The
    # order of the markups has an impact of where the final marker breaks
    # will be. Once this supports edits, the application on markups there will
    # also have an impact on marker placement
    def append(text, markups = [])
      # we want to hold a list of ranges here, so we can support edits later, but
      # also because it makes serialisation easier too

      # Might need to find and join ranges which match markups. Need to decide 
      # what the semanics are here re appending. Might be different to applying
      # to a range. Perhaps we should rejig the order to better line up with existing markups?

      # Is appending: adding text then applying markups to that range? A shorthand

      # OR perhaps this API is different from an 'editor' as it is programatic, rather than a UI?
      # So there _could_ be a "natural" order to the way markers are built
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
      # @cleanup: This feels like something could slip through, ideally this would be
      # an ordered set
      open_markups = []

      serialised = []
      for index in 0..(segments.length - 1) do
        current_segment = segments[index]
        next_segment = segments[index + 1]

        text = current_segment.first
        current_markups = current_segment.last.uniq
        # @incomplete: I think we need to either run this loop backwards or run two passes (maybe a longest chain sorting)
        next_markups = next_segment&.last&.uniq || []

        # Ensure we only open markups that aren't already open
        markups_to_open = current_markups - open_markups

        markups_open_in_current_segment = open_markups + markups_to_open
        # Any markups that are already open, or have just been opened, that aren't in the next segment
        # [underline, strikethrough]
        # [strikethrough]
        markups_to_close = markups_open_in_current_segment - next_markups

        markup_indexes_to_open = markups_to_open
          .sort_by { |markup| [next_markups.include?(markup) ? 1 : 0, markup.tag_name] }
          .map { |markup| ordered_markups.index(markup) }
        number_markups_closed = markups_to_close.length 

        # @magic: '0' is a text markup. Also it might be clearer if this was calling a
        # method to build this perhaps?
        serialised << [0, markup_indexes_to_open, number_markups_closed, text]

        open_markups = markups_open_in_current_segment - markups_to_close
      end

      serialised
    end
  end
end
