$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'mobiledoc/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'mobiledoc'
  s.version     = Mobiledoc::VERSION
  s.authors     = ['Joshua Vermeulen']
  s.email       = ['joshua@martletandco.co.nz']
  s.homepage    = 'https://martletandco.co.nz'
  s.summary     = 'Construct and modify Mobiledoc documents'
  s.license = 'MIT'

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '~> 3.2'
end
