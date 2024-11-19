# frozen_string_literal: true

module YandexTracker
  module Collections
    #
    # Collections::Base
    #
    class Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def inspect
        "#<#{self.class.name}>"
      end

      private

      def build_object(klass, data, context = {})
        klass.new(client, data, context)
      end

      def build_objects(klass, data, context = {})
        data.map { |item| build_object(klass, item, context) }
      end
    end
  end
end
