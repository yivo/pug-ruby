# encoding: UTF-8
# frozen_string_literal: true

Bundler.require
require "stringio"
require "regexp-match-polyfill"

def each_jade_version
  ([:system] + Jade.versions).each { |v| yield(v) }
end

def each_pug_version
  ([:system] + Pug.versions).each do |v|
    next if v.match?(/alpha/)
    yield(v)
  end
end
