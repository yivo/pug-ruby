# encoding: UTF-8
# frozen_string_literal: true

module Jade
  #
  # Used to share common things between compilers.
  #
  module CompilationEssentials
    #
    # Responds for post-processing compilation result.
    #
    # @param source [String] The source code of template.
    # @param result [String] The compiled code of template.
    # @param options [Hash] The compilation options.
    # @return [String]
    def process_result(source, result, options)
      if options[:client]
        "(function(jade) { #{ super }; return #{ options[:name] }; }).call(this, jade);"
      else
        super
      end
    end
  end
end
