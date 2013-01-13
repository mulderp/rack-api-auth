# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-api-auth/version'
require 'rack-api-auth'

Gem::Specification.new do |gem|
  gem.name          = "rack-api-auth"
  gem.version       = Rack::Api::Auth::VERSION
  gem.authors       = ["Patrick Mulder"]
  gem.email         = ["mulder.patrick@gmail.com"]
  gem.description   = %q{Authentication middleware for rack (experimental)}
  gem.summary       = %q{Provide basic paths for authentication, e.g. used with API}
  gem.homepage      = "http://github.com/mulderp/rack-api-auth"
  
  gem.add_development_dependency "rack-test"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
