lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "mache/version"

Gem::Specification.new do |spec|
  spec.name = "mache"
  spec.version = Mache::VERSION
  spec.authors = ["Joshua Bassett"]
  spec.email = ["josh.bassett@gmail.com"]
  spec.summary = "A page object library for writing cleaner acceptance tests with Capybara."
  spec.description = "Mache provides a DSL for writing page object clases to use in your acceptance tests."
  spec.homepage = "https://github.com/nullobject/mache"
  spec.license = "MIT"
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", "~> 2"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rack", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.47"
end
