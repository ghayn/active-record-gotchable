$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "gotchable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active-record-gotchable"
  s.version     = Gotchable::VERSION
  s.authors     = ["ghayn"]
  s.email       = ["ghayn@outlook.com"]
  s.homepage    = "https://github.com/ghayn/active-record-gotchable"
  s.summary     = "A database batch query helper for active record."
  s.description = "Active record gotchable extension"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
end
