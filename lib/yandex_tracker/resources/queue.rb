# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Queue
    #
    class Queue < Base
      def create(**attributes)
        post("queues", attributes)
      end

      def find(id, **params)
        get("queues/#{id}", params)
      end

      def list(**params)
        get("queues", params)
      end
    end
  end
end
