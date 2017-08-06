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
      check_npm_package!

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
      stdout, exit_status = Open3.capture2 "node", "--eval", \
        "console.log(require(#{ JSON.dump(File.join(npm_package_path, "package.json")) }).version)"

      if exit_status.success?
        stdout.strip
      else
        raise engine::ExecutableError, \
          %{Failed to retrieve #{engine.name} version. Perhaps, the problem with Node.js runtime.}
      end
    end
    memoize :version

  protected

    def npm_package_name
      engine.name.downcase
    end

    def npm_package_path
      File.join(npm_packages_root, engine.name.downcase)
    end

    def npm_package_require_snippet
      "require(#{ JSON.dump(npm_package_path) })"
    end

    def require_snippet
      npm_package_require_snippet
    end

    def npm_packages_root
      stdout, exit_status = Open3.capture2("npm", "root", "--global")
      if exit_status.success?
        stdout.strip
      else
        # TODO Use different error?
        raise engine::ExecutableError, \
          "Unable to get NPM packages root. Perhaps, the problem with Node.js runtime."
      end
    end
    memoize :npm_packages_root

    def check_node_runtime!
      stdout, exit_status = Open3.capture2("node", "--version")
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

    def check_npm_package!
      exit_status = Open3.capture2("node", "--eval", "require(#{ JSON.dump(npm_package_path) })")[1]
      unless exit_status.success?
        # TODO Use different error?
        raise engine::ExecutableError, \
          %{No #{engine.name} NPM package found in your system. Did you forget to "npm install --global #{npm_package_name}"?}
      end
      nil
    end
    memoize :check_npm_package!
  end
end
