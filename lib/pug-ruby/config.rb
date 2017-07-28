# encoding: UTF-8
# frozen_string_literal: true

module Pug
  class Config
    # https://pugjs.org/api/reference.html
    # https://github.com/pugjs/pug-cli
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
      @filename                 = nil
      @basedir                  = nil
      @doctype                  = nil
      @pretty                   = false
      @self                     = false
      @debug                    = false
      @compile_debug            = false
      @globals                  = []
      @inline_runtime_functions = true
      @name                     = 'template'
      @name_after_file          = nil
      @out                      = nil
      @extension                = nil
      @silent                   = true
    end

    def to_hash
      %i( filename      basedir         doctype
          pretty        self            debug
          compile_debug globals         inline_runtime_functions
          name          name_after_file out
          extension     silent ).each_with_object({}) { |x, y| y[x] = send(x) }
    end
  end

  singleton_class.class_exec { attr_accessor :config }
  self.config = Config.new
end

