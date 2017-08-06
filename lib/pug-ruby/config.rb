# encoding: UTF-8
# frozen_string_literal: true

module Pug
  #
  # Defines Pug compiler configuration.
  #
  # The documentation for Pug configuration can be found here:
  # - {https://pugjs.org/api/reference.html}
  # - {https://github.com/pugjs/pug-cli}
  #
  class Config < JadePug::Config
    def initialize
      super
      @filename                 = nil
      @basedir                  = nil
      @doctype                  = nil
      @pretty                   = false
      @self                     = false
      @compile_debug            = false
      @globals                  = []
      @inline_runtime_functions = true
      @name                     = "template"
    end
  end
end
