# -*- encoding: utf-8 -*-
require File.expand_path('../lib/airbrake-graylog2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Laurynas Butkus"]
  gem.email         = ["laurynas.butkus@gmail.com"]
  gem.description   = %q{Send Airbrake exceptions to Graylog2}
  gem.summary       = %q{Send Airbrake exceptions to Graylog2}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "airbrake-graylog2"
  gem.require_paths = ["lib"]
  gem.version       = Airbrake::Graylog2::VERSION

  gem.add_runtime_dependency "gelf", '~> 1.3'
  gem.add_runtime_dependency "airbrake", '~> 3.1'
end
