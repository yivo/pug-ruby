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

  protected

    def cli_npm_package_path
      File.expand_path("../../", @path_to_cli_utility)
    end

    def nri_npm_package_path
      File.expand_path("../../", @path_to_cli_utility)
    end
  end
end
