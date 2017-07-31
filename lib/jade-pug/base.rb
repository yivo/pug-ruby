# encoding: UTF-8
# frozen_string_literal: true

require "memoist"

module JadePug
  extend Memoist

  #
  # Compiles the template.
  #
  # @param source [String, #read]
  # @param options [Hash]
  # @return [String]
  def compile(source, options = {})
    compiler(@version).compile(source, options)
  end

  #
  # Returns engine compiler for given version.
  # Compilers are cached.
  #
  # @param version [String, :system]
  # @return [Jade::SystemCompiler, Jade::ShippedCompiler, Pug::SystemCompiler, Pug::ShippedCompiler]
  def compiler(version = @version)
    (@compilers ||= {})["#{name}-#{version}"] ||= begin
      case version
        when :system then self::SystemCompiler.new
        else              self::ShippedCompiler.new(version)
      end
    end
  end

  #
  # Switches compiler version.
  #
  # - If you want to switch compiler to one of that shipped with gem simple pass version as a string.
  # - If you want to switch compiler to system pass :system as a version.
  #
  # Pass block to temporarily switch the version. Without block the version is switched permanently.
  #
  # @param wanted_version [String, :system]
  # @return [void]
  def use(wanted_version)
    previous_version = @version
    @version         = wanted_version
    did_switch_version(previous_version, wanted_version)

    if block_given?
      begin
        yield
      ensure
        @version = previous_version
        did_switch_version(wanted_version, previous_version)
      end
    end
  end

  #
  # Executed after compiler version switched.
  # Outputs some useful information about version being used.
  #
  # @param version_from [String, :system]
  # @param version_to [String, :system]
  # @return [void]
  def did_switch_version(version_from, version_to)
    if version_from != version_to
      if Symbol === version_to
        puts "Using #{version_to} #{name}."
      else
        puts "Using #{name} #{version_to}. NOTE: Advanced features like includes, extends and blocks will not work."
      end
    end
    nil
  end

  #
  # Returns the list of all available engine compiler versions shipped with gem.
  #
  # @return [Array<String>]
  def versions
    Dir[File.expand_path("../../../vendor/#{name.downcase}-*.js", __FILE__)].map do |path|
      match = File.basename(path).match(/\A#{name.downcase}-(?!runtime-)(?<v>.+)\.min\.js\z/)
      match[:v] if match
    end.compact.sort
  end
  memoize :versions

  #
  # Returns the list of all available engine runtime versions shipped with gem.
  #
  # @return [Array<String>]
  def runtime_versions
    Dir[File.expand_path("../../../vendor/#{name.downcase}-*.js", __FILE__)].map do |path|
      match = File.basename(path).match(/\A#{name.downcase}-runtime-(?<v>.+)\.js\z/)
      match[:v] if match
    end.compact.sort
  end
  memoize :runtime_versions

  #
  # Returns version for system-wide installed engine compiler.
  #
  # @return [String]
  def system_version
    compiler(:system).version
  end

  #
  # Returns config object for engine.
  # Executed only once per engine (return value is memoized).
  #
  # @return [Jade::Config, Pug::Config]
  def config
    self::Config.new
  end
  memoize :config
end
