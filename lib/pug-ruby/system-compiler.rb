# encoding: UTF-8
# frozen_string_literal: true

module Pug
  #
  # Abstraction layer for Pug command line utility.
  #
  class SystemCompiler < JadePug::SystemCompiler
    include CompilationEssentials

    def initialize
      super Pug
    end
  end
end
