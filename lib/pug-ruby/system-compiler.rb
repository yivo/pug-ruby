# encoding: UTF-8
# frozen_string_literal: true

require "json"

module Pug
  #
  # Abstraction layer for Pug command line utility.
  #
  class SystemCompiler < JadePug::SystemCompiler
    include CompilationEssentials

    def initialize
      super Pug
    end

    #
    # Compiles Pug template.
    #
    # @param source [String, #read]
    # @param options [Hash]
    # @return [String]
    def compile(source, options = {})
      super do |src, opts|

        # https://github.com/pugjs/pug-cli
        cmd = [executable]

        # Command line arguments take precedence over json options
        # https://github.com/pugjs/pug-cli/blob/master/index.js
        cmd.push("--obj",             JSON.generate(opts))

        cmd.push("--out",             opts[:out])             if opts[:out]
        cmd.push("--path",            opts[:filename])        if opts[:filename]
        cmd.push("--basedir",         opts[:basedir])         if opts[:basedir]
        cmd.push("--pretty")                                  if opts[:pretty]
        cmd.push("--client")                                  if opts[:client]
        cmd.push("--name",            opts[:name])            if opts[:name]
        cmd.push("--no-debug")                                unless opts[:compile_debug]
        cmd.push("--extension",       opts[:extension])       if opts[:extension]
        cmd.push("--silent")                                  if opts[:silent]
        cmd.push("--name-after-file", opts[:name_after_file]) if opts[:name_after_file]
        cmd.push("--doctype",         opts[:doctype])         if opts[:doctype]
        cmd
      end
    end

  protected

    #
    # Returns name for the engine in NPM registry.
    #
    # @return [String]
    def package
      "pug-cli"
    end

    #
    # Responds for the extraction of engine version
    # from output of the command "pug --version".
    #
    # @param output [String]
    # @return [String]
    def extract_version(output)
      output.split(/\n\r?/)[0].to_s["pug version: ".size..-1]
    end
  end
end
