# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Comment resource
    #
    class Comment < Base
      def create(issue_id, **attributes)
        post("issues/#{encode_path(issue_id)}/comments", attributes)
      end

      def list(issue_id, **params)
        get("issues/#{encode_path(issue_id)}/comments", params)
      end
    end
  end
end
