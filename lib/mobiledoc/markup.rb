module Mobiledoc::Markup
  class Base
    def self.serialise
      # If the markup isn't an instance then it won't have options
      [self.tag_name]
    end

    def serialise
      # Markups that require options are expected to be instances with an
      # `options` method
      [tag_name].concat(options).compact
    end

    def self.tag_name
      self.const_get('TAG_NAME')
    end

    def tag_name
      self.class.tag_name
    end
  end

  class Anchor < Base
    TAG_NAME = 'a'.freeze

    attr_accessor :href

    def initialize(href)
      @href = href
    end

    private

    def options
      [href]
    end
  end

  class Bold < Base
    TAG_NAME = 'b'.freeze
  end

  class Code < Base
    TAG_NAME = 'code'.freeze
  end

  class Emphasis < Base
    TAG_NAME = 'em'.freeze
  end

  class Italic < Base
    TAG_NAME = 'i'.freeze
  end

  class StrikeThrough < Base
    TAG_NAME = 's'.freeze
  end

  class Strong < Base
    TAG_NAME = 'strong'.freeze
  end

  class Subscript < Base
    TAG_NAME = 'sub'.freeze
  end

  class Superscript < Base
    TAG_NAME = 'sup'.freeze
  end

  class Underline < Base
    TAG_NAME = 'u'.freeze
  end
end
