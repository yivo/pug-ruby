# encoding: UTF-8
# frozen_string_literal: true

module Jade
  #
  # Abstraction layer for Jade command line utility.
  #
  class SystemCompiler < JadePug::SystemCompiler
    include CompilationEssentials

    def initialize
      super Jade
    end
  end
end
