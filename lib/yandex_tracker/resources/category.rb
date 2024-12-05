# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Category
    #
    class Category < Base
      def list(**params)
        get("fields/categories", params)
      end

      def create(**attributes)
        post("fields/categories", attributes)
      end

      def find(id)
        get("fields/categories/#{id}")
      end
    end
  end
end
