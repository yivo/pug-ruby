# encoding: UTF-8
# frozen_string_literal: true

require "regexp-match-polyfill"

module JadePug
  #
  # Defines template engine compiler configuration.
  #
  class Config
    #
    # Allows to dynamically set config attributes.
    #
    def method_missing(name, *args, &block)
      return super if block

      case args.size
        when 0

          # config.client?
          if name =~ /\A(\w+)\?\z/
            !!(respond_to?($1) ? send($1) : instance_variable_get("@#{ $1 }"))

          # config.client
          elsif name =~ /\A(\w+)\z/
            instance_variable_get("@#{ $1 }")

          else
            super
          end

        when 1
          # config.client=
          if name =~ /\A(\w+)=\z/
            instance_variable_set("@#{ $1 }", args.first)
          else
            super
          end
        else
          super
      end
    end

    def respond_to_missing?(name, include_all)
      name.match?(/\A\w+[=?]?\z/)
    end

    #
    # Transforms config to the hash with all keys symbolized.
    #
    # @return [Hash]
    def to_hash
      instance_variables.each_with_object({}) do |var, h|
        h[var[1..-1].to_sym] = instance_variable_get(var)
      end
    end

    alias to_h to_hash
  end
end
