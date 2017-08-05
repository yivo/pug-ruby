# encoding: UTF-8
# frozen_string_literal: true

require "json"

module Jade
  #
  # Abstraction layer for Jade command line utility.
  #
  class SystemCompiler < JadePug::SystemCompiler
    include CompilationEssentials

    def initialize
      super Jade
    end

    #
    # Compiles Jade template.
    #
    # @param source [String, #read]
    # @param options [Hash]
    # @return [String]
    def compile(source, options = {})
      super do |src, opts|
        # http://web.archive.org/web/*/http://jade-lang.com/command-line/
        cmd = [executable]

        # Command line arguments take precedence over json options
        # https://github.com/pugjs/pug/blob/v1.x.x/bin/jade.js
        cmd.push("--obj",             JSON.generate(opts))

        cmd.push("--out",             opts[:out])             if opts[:out]
        cmd.push("--path",            opts[:filename])        if opts[:filename]
        cmd.push("--basedir",         opts[:basedir])         if opts[:basedir]
        cmd.push("--pretty")                                  if opts[:pretty]
        cmd.push("--client")                                  if opts[:client]
        cmd.push("--name",            opts[:name])            if opts[:name]
        cmd.push("--no-debug")                                unless opts[:compile_debug]
        cmd.push("--extension",       opts[:extension])       if opts[:extension]
        cmd.push("--hierarchy",       opts[:hierarchy])       if opts[:hierarchy]
        cmd.push("--name-after-file", opts[:name_after_file]) if opts[:name_after_file]
        cmd.push("--doctype",         opts[:doctype])         if opts[:doctype]
        cmd
      end
    end
  end
end
