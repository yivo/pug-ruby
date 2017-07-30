# encoding: UTF-8
# frozen_string_literal: true

module JadePug
  #
  # Used when something is wrong with engine compiler executable, for example:
  # - when executable couldn't be found
  # - when executable unexpectedly returned non-zero exit during version check
  #
  class ExecutableError < StandardError

  end
end
