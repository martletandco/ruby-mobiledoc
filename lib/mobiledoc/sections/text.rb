module Mobiledoc::Section

  class Segment
    attr_accessor :text, :markups

    def initialize(text, markups = [])
      @text = text
      @markups = markups.uniq
    end
  end

  class Text
    SECTION_ID = 0.freeze

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
      segments << Segment.new(text, markups) unless text.nil?
    end

    def markups
      Set.new segments.map { |segment| segment.markups }.flatten
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

        next_markups = next_segment&.markups || []

        # Ensure we only open markups that aren't already open
        prev_partitions = partition_trunk(open_markups, current_segment.markups)
        markups_already_open = prev_partitions[0]
        # prev_partitions[1] should always be empty since no markups should be left open that aren't used in this segment
        markups_to_open = prev_partitions[2]
        markups_open_in_current_segment = markups_already_open + markups_to_open

        # Any markups that are already open, or have just been opened, that aren't in the next segment
        next_partitions = partition_trunk(markups_open_in_current_segment, next_markups)
        markups_to_close = next_partitions[1]

        # Get the document index of markups
        markup_indexes_to_open = markups_to_open.map { |markup| ordered_markups.index(markup) }
        number_markups_closed = markups_to_close.length 

        serialised << [SECTION_ID, markup_indexes_to_open, number_markups_closed, current_segment.text]

        open_markups = markups_open_in_current_segment - markups_to_close
      end

      serialised
    end

    # Returns three arrays
    # - first is the ordered union pinned to the start of the arrays
    # - second is everything past the union from a
    # - third is everything past the union from b
    # e.g a: [1, 2, 3, 4, 5], b: [1, 2, 3, 6, 7, 8]
    # returns [[1, 2, 3], [4, 5], [6, 7, 8]]
    def partition_trunk(a, b)
      partition_index = nil
      for index in 0..(a.length-1) do
        break if a[index] != b[index]
        partition_index = index
      end

      # Handle non-overlap case
      return [[], a, b] if partition_index.nil?

      return [
        a[0..partition_index],
        a[partition_index+1..a.length],
        b[partition_index+1..b.length],
      ]
    end
  end
end
