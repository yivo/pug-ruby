# encoding: UTF-8
# frozen_string_literal: true

require "open3"
require "json"

module JadePug
  #
  # Abstraction layer for engine command line utility.
  #
  class SystemCompiler < Compiler
    #
    # @param engine [Jade, Pug]
    def initialize(engine)
      super(engine, nil)

      check_node_runtime!
      check_cli_npm_package!
      check_nri_npm_package!

      engine.echo "Resolved system #{engine.name} to #{version}."
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
      command = ["node", "--eval"]
      command.push compilation_snippet \
        method:    "compile#{"Client" if options[:client]}",
        arguments: [source, options],
        locals:    options.fetch(:locals, {}),
        options:   options
      stdout, stderr, exit_status = Open3.capture3(*command)
      raise engine::CompilationError, stderr unless exit_status.success?
      process_result(source, stdout, options)
    end

    #
    # Returns version of engine installed system-wide.
    #
    # @return [String, nil]
    def version
      load_versions
      @version
    end

    def cli_version
      load_versions
      @cli_version
    end

  protected

    def load_versions
      check_node_runtime!
      check_cli_npm_package!
      check_nri_npm_package!

      snippet = <<-JAVASCRIPT
        console.log(require(#{ JSON.dump(nri_npm_package_path + "/package.json") }).version);
        console.log(require(#{ JSON.dump(cli_npm_package_path + "/package.json") }).version);
      JAVASCRIPT

      stdout, stderr, exit_status = Open3.capture3("node", "--eval", snippet)

      if exit_status.success?
        lines        = stdout.split(/[\n\r]+/).map(&:strip).reject(&:empty?)
        @version     = lines[0]
        @cli_version = lines[1]
      else
        raise engine::ExecutableError, \
          %{Failed to retrieve #{engine.name} version. Perhaps, the problem with Node.js runtime.}
      end
    end
    memoize :load_versions

    def cli_executable_name
      engine.name.downcase
    end

    #
    # Returns name for the engine in NPM registry.
    # By default it tries to guess the name.
    # Derived compilers may override it for custom behavior.
    #
    # @return [String]
    def cli_npm_package_name
      engine.name.downcase
    end

    def cli_npm_package_path
      method_not_implemented
    end

    def nri_npm_package_name
      engine.name.downcase
    end

    def nri_npm_package_path
      method_not_implemented
    end

    def nri_npm_require_snippet
      <<-JAVASCRIPT
        require(#{ JSON.dump(nri_npm_package_path) })
      JAVASCRIPT
    end

    def require_snippet
      nri_npm_require_snippet
    end

    def check_node_runtime!
      stdout, stderr, exit_status = Open3.capture3("node", "--version")

      if exit_status.success?
        engine.echo "Node.js #{stdout.strip}."
      else
        # TODO Use different error?
        raise engine::ExecutableError, \
          "No Node.js runtime found in your system."
      end
      nil
    end
    memoize :check_node_runtime!

    def check_cli_npm_package!
      stdout, stderr, exit_status = Open3.capture3("which", cli_executable_name)

      if File.exists?(stdout.strip)
        @path_to_cli_utility = File.realpath(stdout.strip)
      else
        # TODO Use different error?
        raise engine::ExecutableError, \
          %{No #{engine.name} CLI utility found in your system. Did you forget to "npm install --global #{cli_npm_package_name}"?}
      end
      nil
    end
    memoize :check_cli_npm_package!

    def check_nri_npm_package!
      stdout, stderr, exit_status = Open3.capture3("node", "--eval", nri_npm_require_snippet)

      unless exit_status.success?
        # TODO Use different error?
        raise engine::ExecutableError, \
          %{No #{engine.name} NPM package found in your system. Did you forget to install?}
      end
      nil
    end
    memoize :check_nri_npm_package!
  end
end
