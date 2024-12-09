# frozen_string_literal: true

module YandexTracker
  module Collections
    #
    # Collections::Categories
    #
    class Categories < Base
      def initialize(client)
        super
        @resource = Resources::Category.new(client)
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Category, response)
      end

      def create(**attributes)
        response = resource.create(**attributes)
        build_object(Objects::Category, response)
      end

      def list(**params)
        response = resource.list(**params)
        build_objects(Objects::Category, response)
      end

      private

      attr_reader :resource
    end
  end
end
