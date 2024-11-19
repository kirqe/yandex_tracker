# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Comment
    #
    class Comment < Base
      def create(issue_id, **attributes)
        post("issues/#{issue_id}/comments", attributes)
      end

      def update(issue_id, comment_id, **attributes)
        patch("issues/#{issue_id}/comments/#{comment_id}", attributes)
      end

      def list(issue_id, **params)
        get("issues/#{issue_id}/comments", params)
      end
    end
  end
end
