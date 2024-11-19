# frozen_string_literal: true

require_relative "../resources/queue"
require_relative "../objects/queue"
require_relative "base"

module YandexTracker
  module Collections
    #
    # Collections::Queues
    #
    class Queues < Base
      def initialize(client)
        super
        @resource = Resources::Queue.new(client)
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Queue, response)
      end

      def create(**attributes)
        response = resource.create(**attributes)
        build_object(Objects::Queue, response)
      end

      def list(**params)
        response = resource.list(**params)
        build_objects(Objects::Queue, response)
      end

      private

      attr_reader :resource
    end
  end
end
