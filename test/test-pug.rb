# encoding: UTF-8
# frozen_string_literal: true

require_relative "helper"

class PugTest < Test::Unit::TestCase
  each_pug_version do |version|
    define_method "test_compiler_switching_#{version}" do
      Pug.use version
      assert_equal(version == :system ? "2.0.0-beta6" : version, Pug.compiler.version)
    end

    define_method "test_compilation_#{version}" do
      Pug.use version
      file     = expand_path("index.pug")
      template = File.read(file)
      result   = Pug.compile(template, client: true)
      assert_match_template_function(result)
      assert_no_match_doctype(result)
    end

    define_method "test_compilation_with_io_#{version}" do
      Pug.use version
      template = "div\n  | Hello, world!"
      io       = StringIO.new(template)
      assert_equal(Pug.compile(template), Pug.compile(io))
    end

    define_method "test_compilation_error_#{version}" do
      Pug.use version
      assert_raise(Pug::CompilationError) { Pug.compile("else\n  div") }
    end
  end

  def test_includes
    Pug.use :system
    file     = expand_path("includes/index.pug")
    template = File.read(file)
    result   = Pug.compile(template, filename: file, client: false)
    assert_match_doctype(result)
  end

  def test_extends
    Pug.use :system
    file     = expand_path("extends/index.pug")
    template = File.read(file)
    result   = Pug.compile(template, filename: file, client: false)
    assert_match_doctype(result)
  end

  def test_includes_client
    Pug.use :system
    file     = expand_path("includes/index.pug")
    template = File.read(file)
    result   = Pug.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

  def test_extends_client
    Pug.use :system
    file     = expand_path("extends/index.pug")
    template = File.read(file)
    result   = Pug.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

protected

  def expand_path(relative_path)
    File.expand_path(File.join("../pug", relative_path), __FILE__)
  end

  def assert_match_doctype(string)
    assert_match(/^\s*<!DOCTYPE html>/, string)
  end

  def assert_no_match_doctype(string)
    assert_no_match(/^\s*<!DOCTYPE html>/, string)
  end

  def assert_match_template_function(string)
    assert_match(/function\s+#{Pug.config.name}\s*\(locals\)\s*\{.*\}/m, string)
  end
end
