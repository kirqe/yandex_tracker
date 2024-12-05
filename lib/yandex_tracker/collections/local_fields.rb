# frozen_string_literal: true

require_relative "../resources/field"
require_relative "../objects/field"
require_relative "base"

module YandexTracker
  module Collections
    #
    # Collections::LocalFields
    #
    class LocalFields < Base
      attr_reader :queue_id

      def initialize(client, queue_id)
        raise ArgumentError, "queue_id is required" if queue_id.nil?

        super(client)
        @resource = Resources::LocalField.new(client)
        @queue_id = queue_id
      end

      def find(key)
        response = resource.find(queue_id, key)
        build_object(Objects::LocalField, response)
      end

      def create(**attributes)
        response = resource.create(queue_id, **attributes)
        build_object(Objects::LocalField, response)
      end

      def list(**params)
        response = resource.list(queue_id, **params)
        build_objects(Objects::LocalField, response)
      end

      private

      attr_reader :resource
    end
  end
end
