# encoding: UTF-8
# frozen_string_literal: true

Bundler.require :default, :development
require "stringio"
require "regexp-match-polyfill"

Jade.silence = true
Pug.silence  = true

Test::Unit::TestCase.test_order = :random

module JadePugTestHelpers
  def engine
    Object.const_get self.class.name.gsub(/Test\z/, "")
  end

  def each_version
    ([:system] + engine.versions).each { |v| yield(v) }
  end

  def ext
    ".#{ engine.name.downcase }"
  end

  def expand_path(relative_path)
    File.expand_path(File.join("../#{ engine.name.downcase }", relative_path), __FILE__)
  end

  def assert_match_doctype(string)
    assert_match(doctype_regex, string)
  end

  def assert_no_match_doctype(string)
    assert_no_match(doctype_regex, string)
  end

  def assert_match_template_function(string)
    assert_match(template_function_regex, string)
  end

  def assert_no_match_template_function(string)
    assert_no_match(template_function_regex, string)
  end

  def doctype_regex
    /[<\\u003C]!DOCTYPE html[>\\u003E]/
  end

  def template_function_regex
    /function\s+#{engine.config.name}\s*\(locals\)\s*\{.*\}/m
  end
end

module JadePugTest
  def self.included(base)
    base.class_eval do
      include JadePugTestHelpers

      versions = [:system] + Object.const_get(base.name.gsub(/Test\z/, "")).versions
      versions = [:system] if ENV["QUICK"]

      versions.each do |version|
        test "compilation_#{ version }" do
          engine.use version
          result = engine.compile("div Hello, world!")
          assert_no_match_template_function(result)
          assert_no_match_doctype(result)
        end

        test "compilation_with_doctype_#{ version }" do
          engine.use version
          result = engine.compile(File.read(expand_path("index#{ ext }")))
          assert_no_match_template_function(result)
          assert_match_doctype(result)
        end

        test "compilation_with_io_#{ version }" do
          engine.use version
          template = "div\n  | Hello, world!"
          io       = StringIO.new(template)
          assert_equal(engine.compile(template), engine.compile(io))
        end

        test "compilation_with_syntax_error_#{ version }" do
          engine.use version
          assert_raise(engine::CompilationError) { engine.compile("else\n  div") }
        end

        test "client_compilation_#{ version }" do
          engine.use version
          result = engine.compile("div Hello, world!", client: true)
          assert_match_template_function(result)
          assert_no_match_doctype(result)
        end

        test "client_compilation_with_doctype_#{ version }" do
          engine.use version
          result = engine.compile(File.read(expand_path("index#{ ext }")), client: true)
          assert_match_template_function(result)
          assert_match_doctype(result)
        end

        test "compilation_with_locals_#{ version }" do
          engine.use version
          template = "div=greeting"
          result   = engine.compile(template, locals: { greeting: "Hello, world!" })
          assert_no_match_template_function(result)
          assert_match("Hello, world!", result)
          assert_no_match(/greeting/, result)
        end

        test "client_compilation_with_locals_#{ version }" do
          engine.use version
          template = "div=greeting"
          result   = engine.compile(template, locals: { greeting: "Hello, world!" }, client: true)
          assert_match_template_function(result)
          assert_no_match(/Hello, world!/, result)
          assert_match("greeting", result)
        end

        test "switch_version_permanently_#{ version }" do
          engine.use version
          assert_equal(version == :system ? engine.versions.last : version, engine.compiler.version)
        end

        test "switch_version_temporarily_#{ version }" do
          was     = engine.compiler.system? ? :system : engine.compiler.version
          @called = false
          engine.use(version) { @called = true }
          assert_equal(engine.compiler.system? ? :system : engine.compiler.version, was)
          assert @called
        end
      end
    end
  end

  def test_compilation_with_includes
    engine.use :system
    file     = expand_path("includes/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file)
    assert_no_match_template_function(result)
    assert_match_doctype(result)
  end

  def test_compilation_with_extends
    engine.use :system
    file     = expand_path("extends/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file)
    assert_no_match_template_function(result)
    assert_match_doctype(result)
  end

  def test_client_compilation_with_includes
    engine.use :system
    file     = expand_path("includes/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_match_doctype(result)
  end

  def test_client_compilation_with_extends
    engine.use :system
    file     = expand_path("extends/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_match_doctype(result)
  end

  def test_version_list
    assert_equal engine == Jade ? "1.0.0"  : "2.0.0-beta1", engine.versions.first
    assert_equal engine == Jade ? "1.11.0" : "2.0.0-rc.4",  engine.versions.last
  end

  def test_runtime_version_list
    assert_equal engine == Jade ? "1.0.0"  : "2.0.0", engine.runtime_versions.first
    assert_equal engine == Jade ? "1.11.0" : "2.0.2", engine.runtime_versions.last
  end

  def test_config_serialization
    %i[filename doctype pretty].each do |option|
      assert_include engine.config.to_h.keys, option
    end
  end

  def test_config_customization
    engine.config.custom_option = "value"
    assert_equal "value", engine.config.custom_option
    assert engine.config.custom_option?
    assert_include engine.config.to_h.keys, :custom_option
  end

  def test_get_known_compiler
    assert engine::ShippedCompiler === engine.compiler(engine.versions.sample)
  end

  def test_get_unknown_compiler
    assert_raise(engine::CompilerError) { engine.compiler "0.0.0" }
  end
end
