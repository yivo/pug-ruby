# encoding: UTF-8
# frozen_string_literal: true

module JadePug
  #
  # Used when something is wrong with shipped engine compiler, for example:
  # - when compiler source couldn't be read (file is missing or permissions problem?)
  # - when compiler couldn't be compiled (when ExecJS fails to compile JavaScript code)
  #
  class CompilerError < StandardError

  end
end
