# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'whereabouts/version'

Gem::Specification.new do |s|
  s.name          = 'whereabouts'
  s.version       = Whereabouts::VERSION
  s.authors       = ['Nicholas Fine']
  s.email         = 'nick@ndfine.com'
  s.homepage      = 'http://github.com/yrgoldteeth/whereabouts'
  s.licenses      = ['MIT']
  s.description   = 'Rails plugin for adding associated addresses to Active Record Models'
  s.summary       = 'Whereabouts - has_whereabouts :address'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord'
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
end

