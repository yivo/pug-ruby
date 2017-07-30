# encoding: UTF-8
# frozen_string_literal: true

module Pug
  #
  # Used when something is wrong with Pug executable, for example:
  # - when executable couldn't be found
  # - when executable unexpectedly returned non-zero exit during version check
  #
  class ExecutableError < JadePug::ExecutableError

  end
end
