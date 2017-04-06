lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "mache/version"

Gem::Specification.new do |spec|
  spec.name = "mache"
  spec.version = Mache::VERSION
  spec.authors = ["Joshua Bassett"]
  spec.email = ["josh.bassett@gmail.com"]
  spec.summary = "A library for writing cleaner and more expressive acceptance tests using page objects."
  spec.description = "Mâché provides helps you to write cleaner and more expressive acceptance tests for your web applications using page objects."
  spec.homepage = "https://github.com/nullobject/mache"
  spec.license = "MIT"
  spec.files = `git ls-files --exclude-standard -z -- lib/* CHANGELOG.md LICENSE.md README.md`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", "~> 2"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rack", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.47"
end
