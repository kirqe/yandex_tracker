# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Field
    #
    class Field < Base
      def list(**params)
        get("fields", params)
      end

      def create(**attributes)
        post("fields", attributes)
      end

      def find(id)
        get("fields/#{id}")
      end
    end
  end
end
