# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Base
    #
    class Base
      attr_reader :client, :data, :context

      def initialize(client, data, context = {})
        @client = client
        @data = data
        @context = context
        refresh_from(data)
      end

      def id
        data["id"]
      end

      def method_missing(name, *args)
        key = name.to_s
        return wrap_value(data[key]) if data.key?(key)

        super
      end

      def respond_to_missing?(name, include_private = false)
        data.key?(name.to_s) || super
      end

      # fetch full object from .self
      def expand
        return self unless data["self"]

        response = client.conn.get(data["self"]).body
        refresh_from(response)
      end

      protected

      def refresh_from(new_data)
        @data = new_data
        self
      end

      private

      def wrap_value(value)
        case value
        when Hash then wrap_hash(value)
        when Array then value.map { |v| wrap_value(v) }
        else value
        end
      end

      def wrap_hash(hash)
        return hash unless hash["self"]

        resource_type = hash["self"].split("/").last(2).first
        object_class = classify(resource_type)

        return hash unless object_class

        object_class.new(client, hash, context)
      end

      def classify(type)
        class_name = type.split(/(?=[A-Z])/).map(&:capitalize).join.chomp("s")
        Objects.const_get(class_name)
      rescue NameError
        nil
      end

      def build_objects(klass, data)
        data.map { |item| klass.new(client, item, context) }
      end
    end
  end
end
