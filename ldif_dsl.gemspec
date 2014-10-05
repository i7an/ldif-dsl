$:.push File.expand_path("../lib", __FILE__)
require "ldif/version"

Gem::Specification.new do |s|
  s.name        = "ldif-dsl"
  s.version     = LDIF::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ivan Yurchenko']
  s.email       = ['vanya.yu@gmail.com']
  s.homepage    = ''
  s.summary     = %q{DSL for building ldif config for ladle server}
  s.description = %q{DSL for building ldif config for ladle server}

  s.add_dependency 'docile'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = %w[lib]
end