# frozen_string_literal: true

require_relative "../resources/resolution"
require_relative "../objects/resolution"
require_relative "base"

module YandexTracker
  module Collections
    #
    # Collections::Resolutions
    #
    class Resolutions < Base
      def initialize(client)
        super
        @resource = Resources::Resolution.new(client)
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Resolution, response)
      end

      def list(**params)
        response = resource.list(**params)
        build_objects(Objects::Resolution, response)
      end

      private

      attr_reader :resource
    end
  end
end
