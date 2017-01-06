# encoding: utf-8
# frozen_string_literal: true

module Jade
  class Config
    # http://web.archive.org/web/20160404025722/http://jade-lang.com/api/
    # http://web.archive.org/web/20160618141847/http://jade-lang.com/command-line/
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
      @name            = 'template'
      @name_after_file = nil
      @out             = nil
      @extension       = nil
      @hierarchy       = false
    end

    def to_hash
      %i( filename      doctype         pretty
          self          debug           compile_debug
          cache         globals         client
          name          name_after_file out
          extension     hierarchy ).each_with_object({}) { |x, y| y[x] = send(x) }
    end
  end

  class << self; attr_accessor :config; end
  self.config = Config.new
end
