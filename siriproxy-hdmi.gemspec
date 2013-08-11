# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-hdmi"
  s.version     = "1.0.0"
  s.authors     = ["fryguy"]
  s.email       = [""]
  s.homepage    = "https://github.com/fryguy04/siriproxy-hdmi"
  s.summary     = %q{SiriProxy plugin to control whole house HDMI Switch}
  s.description = %q{SiriProxy plugin to control whole house HDMI Switch}

  s.rubyforge_project = ""

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency "siriproxy", ">=0.5.2"



end
 
