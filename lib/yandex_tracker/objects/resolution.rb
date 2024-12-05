# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Resolution
    #
    class Resolution < Base
      private

      def resource
        @resource ||= Resources::Resolution.new(client)
      end
    end
  end
end
