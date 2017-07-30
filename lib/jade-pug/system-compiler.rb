# encoding: UTF-8
# frozen_string_literal: true

require "open3"

module JadePug
  #
  # Abstraction layer for engine command line utility.
  #
  class SystemCompiler < Compiler
    #
    # @param engine [Jade, Pug]
    def initialize(engine)
      super(engine, nil)
      check_executable!
    end

    #
    # Compiles the template.
    #
    # @param source [String, #read]
    # @param options [hash]
    # @return [String]
    def compile(source, options = {})
      source  = prepare_source(source)
      options = prepare_options(options)
      command = yield(source, options)
      stdout, stderr, exit_status = Open3.capture3(*command, stdin_data: source)
      raise engine::CompilationError, stderr unless exit_status.success?
      process_result(source, stdout, options)
    end

    #
    # Checks if executable exists in $PATH.
    #
    # The method of check is described in this Stack Overflow answer:
    # {https://stackoverflow.com/a/3931779/2369428}
    #
    # @raise {Jade::ExecutableError, Pug::ExecutableError}
    #   If no executable found in the system.
    # @return [void]
    def check_executable!
      return if @executable_checked

      stdout, stderr, exit_status = Open3.capture3("type", executable)

      if exit_status.success?
        @executable_checked = true
      else
        raise engine::ExecutableError, \
          %{No #{engine.name} executable found in your system. Did you forget to "npm install --global #{package}"?}
      end
      nil
    end

    #
    # Returns version of engine installed system-wide.
    #
    # @return [String, nil]
    def version
      @version ||= begin
        check_executable!

        stdout, stderr, exit_status = Open3.capture3(executable, "--version")

        if exit_status.success?
          extract_version(stdout.strip)
        else
          raise engine::ExecutableError, \
            %{Failed to retrieve #{engine.name} version. Perhaps, the problem with Node.js runtime.}
        end
      end
    end

  protected

    #
    # Responds for the extraction of engine version
    # from output of the command "pug --version".
    #
    # @param output [String]
    # @return [String]
    def extract_version(output)
      output
    end

    #
    # Returns executable name for the engine.
    # By default it tries to guess the name.
    # Derived compilers may override it for custom behavior.
    #
    # @return [String]
    def executable
      engine.name.downcase
    end

    #
    # Returns name for the engine in NPM registry.
    # By default it tries to guess the name.
    # Derived compilers may override it for custom behavior.
    #
    # @return [String]
    def package
      engine.name.downcase
    end
  end
end
