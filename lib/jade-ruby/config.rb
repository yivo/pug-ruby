# encoding: UTF-8
# frozen_string_literal: true

module Jade
  #
  # Defines Jade compiler configuration.
  #
  # The documentation for Jade compiler can be found here:
  # - {http://web.archive.org/web/20160404025722/http://jade-lang.com/api/}
  # - {http://web.archive.org/web/20160618141847/http://jade-lang.com/command-line/}
  #
  class Config < JadePug::Config
    attr_accessor :filename
    attr_accessor :doctype
    attr_accessor :pretty
    attr_accessor :self
    attr_accessor :debug
    attr_accessor :compile_debug
    attr_accessor :cache
    attr_accessor :globals
    attr_accessor :client
    attr_accessor :name
    attr_accessor :name_after_file
    attr_accessor :out
    attr_accessor :extension
    attr_accessor :hierarchy

    def initialize
      @filename        = nil
      @doctype         = nil
      @pretty          = false
      @self            = false
      @debug           = false
      @compile_debug   = false
      @cache           = false
      @globals         = []
      @client          = false
      @name            = "template"
      @name_after_file = nil
      @out             = nil
      @extension       = nil
      @hierarchy       = false
    end
  end
end
