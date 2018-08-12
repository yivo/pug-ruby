# encoding: UTF-8
# frozen_string_literal: true

require File.expand_path("lib/pug-ruby/version", __dir__)

Gem::Specification.new do |s|
  s.name            = "pug-ruby"
  s.version         = PUG_RUBY_GEM_VERSION
  s.author          = "Yaroslav Konoplov"
  s.email           = "eahome00@gmail.com"
  s.summary         = "Compile Jade and Pug from Ruby."
  s.description     = "pug-ruby is a gem that allows you to easily compile Jade and Pug templates from Ruby."
  s.homepage        = "https://github.com/yivo/pug-ruby"
  s.license         = "MIT"

  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ["lib"]

  s.add_dependency             "execjs",                 "~> 2.0"
  s.add_dependency             "memoist",                "~> 0.15"
  s.add_dependency             "regexp-match-polyfill",  "~> 1.0", ">= 1.0.2"
  s.add_dependency             "method-not-implemented", "~> 1.0", ">= 1.0.1"
  s.add_development_dependency "bundler",                "~> 1.7"
end
