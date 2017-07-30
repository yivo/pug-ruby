# encoding: UTF-8
# frozen_string_literal: true

module Jade
  #
  # Used when something is wrong with Jade executable, for example:
  # - when executable couldn't be found
  # - when executable unexpectedly returned non-zero exit during version check
  #
  class ExecutableError < JadePug::ExecutableError

  end
end
