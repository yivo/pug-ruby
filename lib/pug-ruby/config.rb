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
    attr_accessor :filename
    attr_accessor :basedir
    attr_accessor :doctype
    attr_accessor :pretty
    attr_accessor :self
    attr_accessor :debug
    attr_accessor :compile_debug
    attr_accessor :globals
    attr_accessor :inline_runtime_functions
    attr_accessor :name
    attr_accessor :name_after_file
    attr_accessor :out
    attr_accessor :extension
    attr_accessor :silent

    def initialize
      super
      @filename                 = nil
      @basedir                  = nil
      @doctype                  = nil
      @pretty                   = false
      @self                     = false

      @debug                    = false
      @compile_debug            = false
      @globals                  = []
      @inline_runtime_functions = true

      @name                     = "template"

      @name_after_file          = nil
      @out                      = nil
      @extension                = nil
      @silent                   = true
    end
  end
end
