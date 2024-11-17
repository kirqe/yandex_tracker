# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Issue resource
    #
    class Issue < Base
      def create(**attributes)
        post("issues", attributes)
      end

      def find(id, **params)
        get("issues/#{encode_path(id)}", params)
      end

      def list(**params)
        get("issues", params)
      end
    end
  end
end
