# frozen_string_literal: true

module YandexTracker
  module Collections
    #
    # Collections::Fields
    #
    class Fields < Base
      def initialize(client)
        super
        @resource = Resources::Field.new(client)
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Field, response)
      end

      def create(**attributes)
        response = resource.create(**attributes)
        build_object(Objects::Field, response)
      end

      def list(**params)
        response = resource.list(**params)
        build_objects(Objects::Field, response)
      end

      def categories
        @categories ||= Categories.new(client)
      end

      private

      attr_reader :resource
    end
  end
end
