# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'whereabouts/version'

Gem::Specification.new do |s|
  s.name          = 'whereabouts'
  s.version       = Whereabouts::VERSION
  s.authors       = ['Nicholas Fine']
  s.email         = 'nicholas.fine@gmail.com'
  s.homepage      = 'http://github.com/yrgoldteeth/whereabouts'
  s.licenses      = ['MIT']
  s.description   = 'Rails plugin for adding associated addresses to Active Record Models'
  s.summary       = 'Whereabouts - has_whereabouts :address'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency(%q<activerecord>, ['>= 3.0.0'])
  s.add_dependency(%q<activesupport>, ['>= 3.0.0'])
  s.add_development_dependency(%q<rspec>)
  s.add_development_dependency(%q<bundler>)
  s.add_development_dependency(%q<sqlite3>)
  s.add_development_dependency(%q<rake)
end

