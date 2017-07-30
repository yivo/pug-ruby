# encoding: UTF-8
# frozen_string_literal: true

module Pug
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
        if options[:inline_runtime_functions]
          %{ (function() { #{result}; return #{options[:name]}; }).call(this); }
        else
          %{ (function(pug) { #{result}; return #{options[:name]}; }).call(this, pug); }
        end
      else
        super
      end
    end
  end
end
