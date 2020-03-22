module Mobiledoc
  class Document
    VERSION = '0.3.2'.freeze

    def serialise
      {
        version: VERSION,
        markups: [],
        atoms: [],
        cards: [],
        sections: []
      }
    end
  end
end
