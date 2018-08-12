# encoding: UTF-8
# frozen_string_literal: true

require "memoist"
require "method-not-implemented"
require "json"

module JadePug
  #
  # Abstraction layer for engine compiler.
  #
  class Compiler
    extend Memoist

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
      method_not_implemented
    end

    #
    # Returns true if this compiler is a system compiler.
    # Otherwise returns false.
    #
    # @return [true, false]
    def system?
      SystemCompiler === self
    end

    #
    # Returns true if this compiler is a shipped compiler.
    # Otherwise returns false.
    #
    # @return [true, false]
    def shipped?
      ShippedCompiler === self
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
      options.keys.each { |k| options[k.to_s.gsub(/_([a-z])/) { $1.upcase }.to_sym] = options[k] }
      options.delete_if { |k, v| v.nil? }
    end

    #
    # Generates the JavaScript code that is the bridge
    # from the gem to the template engine compiler.
    #
    # The code responds for:
    # - invoking compiler
    # - rendering template function with given locals
    # - returning the result
    #
    # @param :method [String]
    #   The name of engine method to call.
    # @param :arguments [Array<Object>]
    #   The array of arguments to be passed to the method.
    # @param :locals [Hash]
    #   The hash of template local variables to be used to render template.
    # @param :options [Hash]
    #   The hash of options passed to {#compile}.
    # @return [String]
    def compilation_snippet(args)
      method    = args.fetch(:method)
      arguments = args.fetch(:arguments)
      locals    = args.fetch(:locals)
      options   = args.fetch(:options)

      <<-JAVASCRIPT
        (function() {
          var engine   = #{ npm_package_require_snippet };
          var template = engine[#{ JSON.dump(method) }].apply(engine, #{ JSON.dump(arguments) });

          if (typeof template === 'function') {
            template = template(#{ JSON.dump(locals) });
          }

          if (typeof console === 'object' && console !== null && typeof console.log === 'function') {
            console.log(template);
          }

          return template;
        })()
      JAVASCRIPT
    end

    #
    # Returns the JavaScript code used to access engine NPM module.
    #
    # @abstract Derived compilers must implement it.
    # @return [String]
    def npm_package_require_snippet
      method_not_implemented
    end

    #
    # Responds for post-processing compilation result.
    #
    # By default removes leading and trailing whitespace
    # by calling {String#strip} and returns the result.
    # Derived compilers may override it for it's own special behavior.
    #
    # @param source [String] The source code of template.
    # @param result [String] The compiled code of template.
    # @param options [Hash] The compilation options.
    # @return [String]
    def process_result(source, result, options)
      result.strip
    end
  end
end
