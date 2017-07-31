# encoding: UTF-8
# frozen_string_literal: true

require "execjs"

module JadePug
  #
  # Abstraction layer for shipped engine compiler.
  #
  class ShippedCompiler < Compiler
    #
    # @param engine [Jade, Pug] The Jade or Pug module.
    # @param version [String]
    def initialize(engine, version)
      super
      @execjs = compile_compiler_source(read_compiler_source(path_to_compiler_source))
    end

    #
    # Compiles template.
    #
    # @param source [String, #read]
    # @param options [Hash]
    # @return [String]
    def compile(source, options = {})
      source  = prepare_source(source)
      options = prepare_options(options)
      result  = if block_given?
        yield
      else
        @execjs.call("#{engine.name.downcase}.compile#{"Client" if options[:client]}", source, options)
      end
      process_result(source, result, options)
    rescue ExecJS::ProgramError => e
      raise engine::CompilationError, e.message
    end

  protected

    #
    # Returns absolute path to the file with compiler source.
    #
    # @return [String]
    def path_to_compiler_source
      File.expand_path("../../../vendor/#{engine.name.downcase}-#{version}.min.js", __FILE__)
    end

    #
    # Reads the compiler source from a file and returns it.
    #
    # @param path [String]
    # @return [String]
    def read_compiler_source(path)
      unless File.readable?(path)
        raise engine::CompilerError, "Couldn't read compiler source: #{path}"
      end
      File.read(path)
    end

    #
    # Compiles the compiler from source and returns it as {ExecJS::Runtime}.
    #
    # @param source [String]
    # @return [ExecJS::Runtime]
    def compile_compiler_source(source)
      ExecJS.compile(source).tap do |compiler|
        raise engine::CompilerError, "Failed to compile compiler" unless compiler
      end
    end
  end
end
