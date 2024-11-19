# frozen_string_literal: true

require_relative "base"
require_relative "../collections/issues"
require_relative "../collections/queues"

module YandexTracker
  module Objects
    #
    # Objects::Queue
    #
    class Queue < Base
      def issues
        @issues ||= Collections::Issues.new(client, id)
      end

      def update(**attributes)
        response = resource.update(id, attributes)
        refresh_from(response)
      end

      private

      def resource
        @resource ||= Resources::Queue.new(client)
      end
    end
  end
end
