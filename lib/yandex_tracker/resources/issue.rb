# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Issue
    #
    class Issue < Base
      def create(**attributes)
        post("issues", attributes)
      end

      def update(**attributes)
        patch("issues", attributes)
      end

      def find(id, **params)
        get("issues/#{id}", params)
      end

      def list(**params)
        get("issues", params)
      end

      def transition(issue_id, transition_id, **attributes)
        post("issues/#{issue_id}/transitions/#{transition_id}/_execute", attributes)
      end

      def transitions(issue_id)
        get("issues/#{issue_id}/transitions")
      end

      def search(body = {}, **query_params)
        post("issues/_search", body, query_params)
      end
    end
  end
end
