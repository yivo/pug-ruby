# encoding: UTF-8
# frozen_string_literal: true

module JadePug
  #
  # Abstraction layer for engine compiler.
  #
  class Compiler

    #
    # Returns the engine module.
    #
    # Used in such cases:
    # - used to compute the name for engine
    # - used to refer to the error classes
    #
    # @return [Jade, Pug]
    attr_reader :engine

    #
    # Returns the version of engine compiler.
    #
    # @return [String]
    attr_reader :version

    #
    # @param engine [Jade, Pug]
    # @param version [String]
    def initialize(engine, version)
      @engine  = engine
      @version = version
    end

    #
    # Compiles template.
    #
    # By default does nothing.
    #
    # @abstract Derived compilers must implement it.
    # @param source [String, #read]
    #   The template source code or any object which responds to #read and returns string.
    # @param options [Hash]
    # @return [String]
    def compile(source, options = {})

    end

  protected

    #
    # Reads the template source code.
    # Responds for pre-processing source code.
    # Actually, it just checks if source code responds to #read and if so
    #
    # @param source [String, #read]
    # @return [String]
    def prepare_source(source)
      source.respond_to?(:read) ? source.read : source
    end

    #
    # Responds for preparing compilation options.
    #
    # The next steps are executed:
    # - is merges options into the engine config
    # - it camelizes and symbolizes every option key
    # - it removes nil values from the options
    #
    # @param options [Hash]
    # @return [Hash]
    def prepare_options(options)
      options = engine.config.to_hash.merge(options)
      options.keys.each { |k, v| options[k.to_s.gsub(/_([a-z])/) { $1.upcase }.to_sym] = options[k] }
      options.delete_if { |k, v| v.nil? }
    end

    #
    # Responds for post-processing compilation result.
    #
    # By default returns the result without any processing.
    # Derived compilers may override it for it's own special behaviors.
    #
    # @param source [String] The source code of template.
    # @param result [String] The compiled code of template.
    # @param options [Hash] The compilation options.
    # @return [String]
    def process_result(source, result, options)
      result
    end
  end
end
