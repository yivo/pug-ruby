# frozen_string_literal: true
require 'pug-ruby'
require 'test/unit'

class JadeTest < Test::Unit::TestCase

  def test_compile
    file     = expand_path('index.jade')
    template = File.read(file)
    result   = Jade.compile(template, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

  def test_compile_with_io
    io = StringIO.new("div\n  | Hello, world!")
    assert_equal(Jade.compile("div\n  | Hello, world!"), Jade.compile(io))
  end

  def test_compilation_error
    assert_raise(Jade::CompileError) { Jade.compile("else\n  div") }
  end

  def test_includes
    file     = expand_path('includes/index.jade')
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: false)
    assert_match_doctype(result)
  end

  def test_extends
    file     = expand_path('extends/layout.jade')
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: false)
    assert_match_doctype(result)
  end

  def test_includes_client
    file     = expand_path('includes/index.jade')
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

  def test_extends_client
    file     = expand_path('extends/layout.jade')
    template = File.read(file)
    result   = Jade.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_no_match_doctype(result)
  end

protected
  def expand_path(relative_path)
    File.expand_path(File.join('..', 'jade', relative_path), __FILE__)
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
