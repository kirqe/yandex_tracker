# frozen_string_literal: true

module YandexTracker
  module Collections
    #
    # Collections::Users
    #
    class Users < Base
      def initialize(client)
        super
        @resource = Resources::User.new(client)
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::User, response)
      end

      def myself(**params)
        response = resource.myself(**params)
        build_object(Objects::User, response)
      end

      def list(**params)
        response = resource.list(**params)
        build_objects(Objects::User, response)
      end

      private

      attr_reader :resource
    end
  end
end
