$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'topograf/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = 'topograf'
  gem.version     = Topograf::VERSION
  gem.authors     = ['Eric Helms']
  gem.email       = ['ericdhelms@gmail.com']
  gem.homepage    = ''
  gem.summary     = ''
  gem.description = 'Analyze Foreman logs for trends'

  gem.files = Dir['/lib'] + ['README.md']
  gem.require_paths = ['lib']

  # Core Dependencies

  # Testing
  gem.add_development_dependency 'rubocop'
end
