# Mobiledoc for Ruby

[Mobiledoc](https://github.com/bustle/mobiledoc-kit) is a simple, platform-agnostic, and extensible format for rich text content

_Author's note: There is a tendency, when considering using Mobiledoc, to be concerned that the format is not easily readible by humans. While this is true to an extent, in practise you rely on libraries (such as this one), and editors to do the low-level work in much the same way you use image manipulation libraries and editors_ 

## Initial goals

- Document builder API
- Document seralise to MobileDoc format
- Parse MobileDoc format to document
- Render documents to HTML, email, text
- Parse HTML to document

## Later goals

- Building documents programatically
- Manipulation of documents, including markups and atoms

## Development

### Installation

(With Ruby 3.2.x and `bundler` installed) run `bundler install`

### Tests

Run `rake test`
