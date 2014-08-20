# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/utils/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-utils'
  spec.version       = Elasticsearch::Utils::VERSION
  spec.authors       = ['Andrew Hammond', 'Bob Breznak']
  spec.email         = ['andrew@evertrue.com', 'bob@evertrue.com']
  spec.summary       = 'Simple utilities built ontop of Elasticsearch'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/evertrue/elasticsearch-utils'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'elasticsearch', '~> 1.0.4'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
end
