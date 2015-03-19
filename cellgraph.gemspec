# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "cellgraph/version"

Gem::Specification.new do |s|
  s.name = "cellgraph"
  s.version = Cellgraph::VERSION
  s.authors = ["Berthold Alheit"]
  s.email = ["behoalheit@gmail.com"]
  s.homepage = "http://www.github.com/elyzion/cellgraph"
  s.summary = "Parent/Child relattions for Activerecord with Celluloid."
  s.description = "Description of Cellgraph."
  s.license = "MIT"

  s.files = Dir["lib/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  # requires git.
  #s.files = `git ls-files`.split($/)
  #s.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  #s.test_files = gem.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "celluloid"
  s.add_dependency "activerecord"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "with_model"
end
