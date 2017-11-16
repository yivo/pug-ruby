# encoding: UTF-8
# frozen_string_literal: true

require_relative "helper"

class JadePugTest < Test::Unit::TestCase
  include JadePugTestHelpers

  test :compilation_with_includes do
    engine.use :system
    file     = expand_path("includes/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file)
    assert_no_match_template_function(result)
    assert_match_doctype(result)
  end

  test :compilation_with_extends do
    engine.use :system
    file     = expand_path("extends/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file)
    assert_no_match_template_function(result)
    assert_match_doctype(result)
  end

  test :client_compilation_with_includes do
    engine.use :system
    file     = expand_path("includes/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_match_doctype(result)
  end

  test :client_compilation_with_extends do
    engine.use :system
    file     = expand_path("extends/index#{ ext }")
    template = File.read(file)
    result   = engine.compile(template, filename: file, client: true)
    assert_match_template_function(result)
    assert_match_doctype(result)
  end

  test :version_list do
    assert_equal engine == Jade ? "1.0.0"  : "2.0.0-beta1", engine.versions.first
    assert_equal engine == Jade ? "1.11.0" : "2.0.0-rc.4",  engine.versions.last
  end

  test :runtime_version_list do
    assert_equal engine == Jade ? "1.0.0"  : "2.0.0", engine.runtime_versions.first
    assert_equal engine == Jade ? "1.11.0" : "2.0.2", engine.runtime_versions.last
  end

  test :config_serialization do
    %i[filename doctype pretty].each do |option|
      assert_include engine.config.to_h.keys, option
    end
  end

  test :config_customization do
    engine.config.custom_option = "value"
    assert_equal "value", engine.config.custom_option
    assert engine.config.custom_option?
    assert_include engine.config.to_h.keys, :custom_option
  end

  test :get_known_compiler do
    assert engine::ShippedCompiler === engine.compiler(engine.versions.sample)
  end

  test :get_unknown_compiler do
    assert_raise(engine::CompilerError) { engine.compiler "0.0.0" }
  end
end
