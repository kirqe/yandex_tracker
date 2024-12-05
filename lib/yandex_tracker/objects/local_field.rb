# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::LocalField
    #
    class LocalField < Base
      private

      def resource
        @resource ||= Resources::LocalField.new(client)
      end
    end
  end
end
