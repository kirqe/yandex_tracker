# frozen_string_literal: true

require "ostruct"

module YandexTracker
  #
  # <Description>
  #
  class ResourceReference < OpenStruct
    def identifier
      key || id
    end

    def to_s
      display || key || id || ""
    end

    def url
      self.self
    end

    def method_missing(method_name, *args)
      return nil if args.empty?

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      return true if args.empty? && !instance_variable_defined?("@#{method_name}")

      super
    end
  end
end
