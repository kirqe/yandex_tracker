# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::LocalField
    #
    class LocalField < Base
      def list(queue_id, **params)
        get("queues/#{queue_id}/localFields", params)
      end

      def create(queue_id, **attributes)
        post("queues/#{queue_id}/localFields", attributes)
      end

      def find(queue_id, key)
        get("queues/#{queue_id}/localFields/#{key}")
      end
    end
  end
end
