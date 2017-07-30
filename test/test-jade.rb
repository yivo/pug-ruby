# encoding: UTF-8
# frozen_string_literal: true

require_relative "helper"

class JadeTest < Test::Unit::TestCase
  each_jade_version do |version|
    define_method "test_compilation_#{version}" do
      Jade.use version
      file     = expand_path("index.jade")
      template = File.read(file)
      result   = Jade.compile(template, client: true)
      assert_match_template_function(result)
      assert_no_match_doctype(result)
    end

    define_method "test_compilation_with_io_#{version}" do
      Jade.use version
      template = "div\n  | Hello, world!"
      io       = StringIO.new(template)
      assert_equal(Pug.compile(template), Pug.compile(io))
    end

    define_method "test_compilation_error_#{version}" do
      Jade.use version
      assert_raise(Jade::CompilationError) { Jade.compile("else\n  div") }
    end
  end

  def test_includes
    Jade.use :system
    file     = expand_path("includes/index.jade")
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: false)
    assert_match_doctype(result)
  end

  def test_extends
    Jade.use :system
    file     = expand_path("extends/layout.jade")
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: false)
    assert_match_doctype(result)
  end

  def test_includes_client
    Jade.use :system
    file     = expand_path("includes/index.jade")
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

  def test_extends_client
    Jade.use :system
    file     = expand_path("extends/layout.jade")
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

protected

  def expand_path(relative_path)
    File.expand_path(File.join("../jade", relative_path), __FILE__)
  end

  def assert_match_doctype(string)
    assert_match(/^\s*<!DOCTYPE html>/, string)
  end

  def assert_no_match_doctype(string)
    assert_no_match(/^\s*<!DOCTYPE html>/, string)
  end

  def assert_match_template_function(string)
    assert_match(/function\s+#{Jade.config.name}\s*\(locals\)\s*\{.*\}/m, string)
  end
end
