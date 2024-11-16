# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # User resource
    #
    class User < Base
      def myself
        response = get("myself")
        Models::User.new(response)
      end

      def list(params = {})
        response = get("users", params)
        response.map { |user_data| Models::User.new(user_data) }
      end

      def find(id)
        response = get("users/#{id}")
        Models::User.new(response)
      end
    end
  end
end
