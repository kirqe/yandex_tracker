# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::User
    #
    class User < Base
      def myself
        get("myself")
      end

      def list(**params)
        get("users", params)
      end

      def find(id)
        get("users/#{id}")
      end
    end
  end
end
