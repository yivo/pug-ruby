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

module JadePugVersionsTest
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
end
