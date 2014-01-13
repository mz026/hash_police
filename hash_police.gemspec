# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_police/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_police"
  spec.version       = HashPolice::VERSION
  spec.authors       = ["Yang-Hsing Lin"]
  spec.email         = ["yanghsing.lin@gmail.com"]
  spec.description   = %q{a gem to check whether given to hashes are of the same format}
  spec.summary       = %q{a gem to check whether given to hashes are of the same format}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "hashie"
  spec.add_development_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
