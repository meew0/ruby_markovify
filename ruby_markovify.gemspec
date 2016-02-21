# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_markovify/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_markovify'
  spec.version       = RubyMarkovify::VERSION
  spec.authors       = ['meew0']
  spec.email         = ['blactbt@live.de']

  spec.summary       = %q{A Ruby port of the excellent `markovify` Python module.}
  spec.homepage      = 'https://github.com/meew0/ruby_markovify'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'unidecode'

  spec.add_development_dependency 'bundler', '~> 1.12.a'
  spec.add_development_dependency 'rake', '~> 10.0'
end
