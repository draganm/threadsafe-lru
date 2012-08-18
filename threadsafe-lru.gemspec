# -*- encoding: utf-8 -*-
require File.expand_path('../lib/threadsafe-lru/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dragan Milic"]
  gem.email         = ["dragan@netice9.com"]
  gem.description   = %q{Thread safe implemenation of in-memory LRU cache compatible with Java Memory Model}
  gem.summary       = %q{Thread safe in memory LRU cache}
  gem.homepage      = "https://github.com/draganm/threadsafe-lru"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "threadsafe-lru"
  gem.require_paths = ["lib"]
  gem.version       = ThreadSafeLru::VERSION
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'autotest'
end
