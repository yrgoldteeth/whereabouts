# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "whereabouts/version"

Gem::Specification.new do |s|
  s.name        = "whereabouts"
  s.version     = Whereabouts::VERSION
  s.authors     = ["Nicholas Fine"]
  s.email       = ["nicholas.fine@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Whereabouts}
  s.description = %q{Whereabouts descriptions}

  s.rubyforge_project = "whereabouts"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
