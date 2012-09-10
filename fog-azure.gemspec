# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fog-azure/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shady Sayed"]
  gem.email         = ["shady.sayed@tagipedia.com"]
  gem.description   = %q{Add azure support to the fog gem}
  gem.summary       = %q{Add azure support to the fog gem}
  gem.homepage      = "https://github.com/shadysayed/fog-azure"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fog-azure"
  gem.require_paths = ["lib"]
  gem.version       = Fog::Azure::VERSION
  
  gem.add_dependency "fog", "~> 1.5.0"
  gem.add_development_dependency "rspec"
end
