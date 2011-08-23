# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sbdevcart/version"

Gem::Specification.new do |s|
  s.name = "sbdevcart"
  s.summary = "Sbdev Shopping Cart"
  s.description = "Sbdev Shopping Cart"
  s.authors     = ["Adam Olsen"]
  s.email       = ["aosalias@gmail.com"]

  s.version     = Sbdevcart::VERSION

  s.rubyforge_project = "sbdev"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('sbdevcore', ">= 0.0.8")
  s.add_dependency('aasm', ">= 2.2.0")
end