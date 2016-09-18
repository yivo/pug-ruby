# frozen_string_literal: true
require 'open3'
require 'json'
require 'shellwords'

module Pug
  class << self
    def compile(source, options = {})
      check_executable!

      source  = source.read if source.respond_to?(:read)
      options = config.to_hash.merge(options)

      # https://github.com/pugjs/pug-cli
      cmd = ['pug']

      options[:compileDebug]           = options[:compile_debug]
      options[:nameAfterFile]          = options[:name_after_file]
      options[:inlineRuntimeFunctions] = options[:inline_runtime_functions]

      options.respond_to?(:compact) ? options.compact : options.delete_if { |k, v| v.nil? }

      # Command line arguments take precedence over json options
      # https://github.com/pugjs/pug-cli/blob/master/index.js
      cmd.push('--obj',             JSON.generate(options))

      cmd.push('--out',             escape(options[:out]))             if options[:out]
      cmd.push('--path',            escape(options[:filename]))        if options[:filename]
      cmd.push('--basedir',         escape(options[:basedir]))         if options[:basedir]
      cmd.push('--pretty')                                             if options[:pretty]
      cmd.push('--client')                                             if options[:client]
      cmd.push('--name',            escape(options[:name]))            if options[:name]
      cmd.push('--no-debug')                                           unless options[:compile_debug]
      cmd.push('--extension',       escape(options[:extension]))       if options[:extension]
      cmd.push('--silent')                                             if options[:silent]
      cmd.push('--name-after-file', escape(options[:name_after_file])) if options[:name_after_file]
      cmd.push('--doctype',         escape(options[:doctype]))         if options[:doctype]

      stdout, stderr, exit_status = Open3.capture3(*cmd, stdin_data: source)
      raise CompileError.new(stderr) unless exit_status.success?
      stdout
    end

    def check_executable!
      unless @executable_checked
        `hash pug`
        unless $?.success?
          raise ExecutableError, 'No pug executable found in your system. Did you forget to "npm install -g pug-cli"?'
        end
        @executable_checked = true
      end
    end

  protected
    def escape(string)
      Shellwords.escape(string)
    end
  end

  class CompileError < StandardError
  end

  class ExecutableError < StandardError
  end
end

