# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Queue resource
    #
    class Queue < Base
      def create(**attributes)
        post("queues", attributes)
      end

      def find(id, **params)
        get("queues/#{encode_path(id)}", params)
      end

      def list(**params)
        get("queues", params)
      end
    end
  end
end
