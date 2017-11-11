# encoding: UTF-8
# frozen_string_literal: true

require "open3"
require "json"

module JadePug
  #
  # Abstraction layer for system engine compiler.
  #
  class SystemCompiler < Compiler
    #
    # @param engine [Jade, Pug]
    def initialize(engine)
      super(engine, nil)

      check_node_runtime!
      check_npm_package!

      engine.echo "Resolved system #{ engine.name } to #{ version }."
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
        method:    "compile#{ "Client" if options[:client] }",
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
    # @return [String]
    def version
      stdout, exit_status = Open3.capture2 "node", "--eval", \
        "console.log(require(#{ JSON.dump(File.join(npm_package_path, "package.json")) }).version)"

      if exit_status.success?
        stdout.strip
      else
        raise engine::CompilerError, \
          %{Failed to get #{ engine.name } version. Perhaps, the problem with Node.js runtime.}
      end
    end
    memoize :version

  protected

    #
    # Return the name of engine NPM package.
    #
    # @return [String]
    def npm_package_name
      engine.name.downcase
    end

    #
    # Returns the path of globally installed engine NPM package.
    #
    # @return [String]
    def npm_package_path
      File.join(npm_packages_root, engine.name.downcase)
    end

    #
    # Returns the JavaScript code used to require engine NPM package.
    #
    # @return [String]
    def npm_package_require_snippet
      "require(#{ JSON.dump(npm_package_path) })"
    end

    #
    # Returns the root directory of globally installed NPM packages.
    #
    # @return [String]
    def npm_packages_root
      stdout, exit_status = Open3.capture2("npm", "root", "--global")

      if exit_status.success?
        stdout.strip
      else
        raise engine::CompilerError, \
          %{Unable to get NPM packages root. Perhaps, the problem with Node.js runtime.}
      end
    end
    memoize :npm_packages_root

    #
    # Checks if Node.js runtime exists in $PATH and is accessible.
    #
    # @raise {JadePug::CompilerError}
    #   If Node.js runtime doesn't exist in system.
    # @return [nil]
    def check_node_runtime!
      stdout, exit_status = Open3.capture2("node", "--version")

      if exit_status.success?
        @node_version = stdout.strip.gsub(/\Av/, "")
        engine.echo "Using Node.js runtime #{ @node_version }."
      else
        raise engine::CompilerError, %{No Node.js runtime has been found in your system.}
      end
      nil
    end
    memoize :check_node_runtime!

    #
    # Checks if engine NPM package is installed.
    #
    # @raise {JadePug::CompilerError}
    #   If engine NPM package is not installed.
    # @return [nil]
    def check_npm_package!
      exit_status = Open3.capture2("node", "--eval", npm_package_require_snippet)[1]

      unless exit_status.success?
        raise engine::CompilerError, \
          %{No #{ engine.name } NPM package has been found in your system. } +
          %{Have you forgotten to "npm install --global #{ npm_package_name }"?}
      end
      nil
    end
    memoize :check_npm_package!
  end
end
