# encoding: UTF-8
# frozen_string_literal: true

require "memoist"

# :nodoc:
module JadePug
  extend Memoist

  #
  # Compiles the template.
  #
  # @param source [String, #read]
  # @param options [Hash]
  # @return [String]
  def compile(source, options = {})
    compiler.compile(source, options)
  end

  #
  # Returns engine compiler for given version.
  # Compilers are cached.
  #
  # @param wanted_version [String, :system]
  # @return [JadePug::Compiler]
  def compiler(wanted_version = version)
    (@compilers ||= {})["#{ name }-#{ wanted_version }"] ||= begin
      case wanted_version
        when :system then self::SystemCompiler.new
        else              self::ShippedCompiler.new(wanted_version)
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
  # @return [String, :system] Returns the version if no block has been given.
  # @return Passes through the returned value from the block if it has been given.
  def use(wanted_version)
    previous_version = version
    @version         = wanted_version
    did_switch_version(previous_version, wanted_version)

    return @version unless block_given?

    begin
      yield
    ensure
      @version = previous_version
      did_switch_version(wanted_version, previous_version)
    end
  end

  #
  # Executed after compiler version switched.
  # Outputs some useful information about version being used.
  #
  # @param version_from [String, :system]
  # @param version_to [String, :system]
  # @return [nil]
  def did_switch_version(version_from, version_to)
    if version_from != version_to
      if Symbol === version_to
        echo "Using #{ version_to } #{ name }."
      else
        echo "Using #{ name } #{ version_to }. NOTE: Advanced features like includes, extends and blocks will not work."
      end
    end
    nil
  end

  #
  # Returns the list of all available engine compiler versions shipped with the gem.
  #
  # @return [Array<String>]
  def versions
    sort_versions(Dir[File.expand_path("../../../vendor/#{ name.downcase }-*.js", __FILE__)].map do |path|
      match = File.basename(path).match(/\A#{name.downcase}-(?!runtime-)(?<v>.+)\.min\.js\z/)
      match[:v] if match
    end.compact)
  end
  memoize :versions

  #
  # Returns the list of all available engine runtime versions shipped with the gem.
  #
  # @return [Array<String>]
  def runtime_versions
    sort_versions(Dir[File.expand_path("../../../vendor/#{ name.downcase }-*.js", __FILE__)].map do |path|
      match = File.basename(path).match(/\A#{name.downcase}-runtime-(?<v>.+)\.js\z/)
      match[:v] if match
    end.compact)
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
  # @return [JadePug::Config]
  def config
    self::Config.new
  end
  memoize :config

  #
  # Prints messages.
  # By default messages are sent to the STDOUT by using {Kernel#puts}.
  #
  # @param *messages [Array<Object>]
  # @return [nil]
  def echo(*messages)
    puts(*messages) unless silence?
  end

  #
  # Turns the effect of {#echo} on or off.
  #
  # @param silence [true, false]
  # @return [true, false]
  def silence=(silence)
    @silence = !!silence
  end

  #
  # Returns true if {#echo} should print messages.
  # Otherwise returns false.
  #
  # @return [true, false]
  def silence?
    !!@silence
  end

  #
  # Returns version of currently used engine compiler.
  # If no version has been set returns :system.
  #
  # Only for internal usage.
  #
  # To get the actual version of engine compiler refer to {Compiler#version}.
  #
  #   Jade.compiler.version => "1.11.0"
  #
  # @return [String, :system]
  def version
    if instance_variable_defined?(:@version)
      @version
    else
      :system
    end
  end
  private :version

  #
  # Sorts versions in ascending order.
  # @see {https://stackoverflow.com/a/33290373/2369428}
  #
  # @param versions [Array<String>]
  # @return [Array<String>]
  def sort_versions(versions)
    versions.sort_by { |v| Gem::Version.new(v) }
  end
  private :sort_versions
end
