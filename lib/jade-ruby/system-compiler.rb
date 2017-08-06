# encoding: UTF-8
# frozen_string_literal: true

module Jade
  #
  # Abstraction layer for system Jade compiler.
  #
  class SystemCompiler < JadePug::SystemCompiler
    include CompilationEssentials

    def initialize
      super Jade
    end
  end
end
