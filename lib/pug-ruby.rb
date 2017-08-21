# encoding: UTF-8
# frozen_string_literal: true

require "pug-ruby/version"

#
# This module contains common thing related Jade and Pug.
#
module JadePug
  autoload :Config,           "jade-pug/config"
  autoload :Compiler,         "jade-pug/compiler"
  autoload :ShippedCompiler,  "jade-pug/shipped-compiler"
  autoload :SystemCompiler,   "jade-pug/system-compiler"
  autoload :CompilationError, "jade-pug/errors/compilation-error"
  autoload :CompilerError,    "jade-pug/errors/compiler-error"
end

require "jade-pug/base"

#
# This module contains all stuff related to Jade template engine.
# See the list below.
#
module Jade
  extend JadePug

  autoload :Config,                "jade-ruby/config"
  autoload :Compiler,              "jade-ruby/compiler"
  autoload :ShippedCompiler,       "jade-ruby/shipped-compiler"
  autoload :SystemCompiler,        "jade-ruby/system-compiler"
  autoload :CompilationEssentials, "jade-ruby/compilation-essentials"
  autoload :CompilationError,      "jade-ruby/errors/compilation-error"
  autoload :CompilerError,         "jade-ruby/errors/compiler-error"
end

#
# This module contains all stuff related to Pug template engine.
# See the list below.
#
module Pug
  extend JadePug

  autoload :Config,                "pug-ruby/config"
  autoload :Compiler,              "pug-ruby/compiler"
  autoload :ShippedCompiler,       "pug-ruby/shipped-compiler"
  autoload :SystemCompiler,        "pug-ruby/system-compiler"
  autoload :CompilationEssentials, "pug-ruby/compilation-essentials"
  autoload :CompilationError,      "pug-ruby/errors/compilation-error"
  autoload :CompilerError,         "pug-ruby/errors/compiler-error"
end
