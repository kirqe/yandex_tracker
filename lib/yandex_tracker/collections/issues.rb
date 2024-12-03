# frozen_string_literal: true

require_relative "../resources/issue"
require_relative "../objects/issue"
require_relative "../collections/base"

module YandexTracker
  module Collections
    #
    # Collections::Issues
    #
    class Issues < Base
      attr_reader :queue_id

      def initialize(client, queue_id = nil)
        super(client)
        @resource = Resources::Issue.new(client)
        @queue_id = queue_id
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Issue, response, { queue_id: queue_id })
      end

      def create(**attributes)
        attributes = attributes.merge(queue: queue_id) if queue_id
        response = resource.create(**attributes)
        build_object(Objects::Issue, response, { queue_id: queue_id })
      end

      def list(**params)
        params = params.merge(queue: queue_id) if queue_id
        response = resource.list(**params)
        build_objects(Objects::Issue, response, { queue_id: queue_id })
      end

      def search(body = {}, **query_params)
        response = resource.search(body, **query_params)
        build_objects(Objects::Issue, response, { queue_id: queue_id })
      end

      def import(body = {}, **query_params)
        response = resource.import(body, **query_params)
        build_objects(Objects::Issue, response, { queue_id: queue_id })
      end

      private

      attr_reader :resource
    end
  end
end
