# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Field
    #
    class Field < Base
      private

      def resource
        @resource ||= Resources::Field.new(client)
      end
    end
  end
end
