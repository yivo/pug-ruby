# encoding: UTF-8
# frozen_string_literal: true

module Pug
  #
  # Abstraction layer for shipped Pug compiler.
  #
  class ShippedCompiler < JadePug::ShippedCompiler
    include CompilationEssentials

    def initialize(version)
      super Pug, version
    end
  end
end
