# frozen_string_literal: true

module YandexTracker
  module Models
    #
    # <Description>
    #
    class Base
      def initialize(attributes = {})
        attributes = convert_references(attributes)
        define_attributes(attributes)
      end

      def method_missing(method_name, *args)
        return nil if args.empty?

        super
      end

      def respond_to_missing?(method_name, include_private = false)
        return true if args.empty? && !instance_variable_defined?("@#{method_name}")

        super
      end

      private

      def define_attributes(attributes)
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
          self.class.send(:attr_reader, key)
        end
      end

      def convert_references(value)
        case value
        when Hash
          convert_hash_values(value)
        when Array
          value.map { |v| convert_references(v) }
        else
          value
        end
      end

      def convert_hash_values(hash)
        return ResourceReference.new(hash) if reference?(hash)

        hash.transform_values { |v| convert_references(v) }
      end

      def reference?(hash)
        hash.key?("id") || hash.key?("key")
      end
    end
  end
end
