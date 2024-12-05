# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Category
    #
    class Category < Base
      private

      def resource
        @resource ||= Resources::Category.new(client)
      end
    end
  end
end
