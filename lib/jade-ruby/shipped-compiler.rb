# encoding: UTF-8
# frozen_string_literal: true

module Jade
  #
  # Abstraction layer for shipped Jade compiler.
  #
  class ShippedCompiler < JadePug::ShippedCompiler
    include CompilationEssentials

    def initialize(version)
      super Jade, version
    end
  end
end
