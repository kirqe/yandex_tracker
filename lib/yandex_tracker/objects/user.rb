# frozen_string_literal: true

require_relative "base"

module YandexTracker
  module Objects
    #
    # Objects::User
    #
    class User < Base
      private

      def resource
        @resource ||= Resources::User.new(client)
      end
    end
  end
end
