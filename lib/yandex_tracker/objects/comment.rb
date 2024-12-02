# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Comment
    #
    class Comment < Base
      def attachments
        @attachments ||= Collections::Attachments.new(client, context[:issue_id], comment_id: id)
      end

      def update(**attributes)
        raise ArgumentError, "issue_id is required" unless context[:issue_id]

        response = resource.update(context[:issue_id], id, **attributes)
        refresh_from(response)
      end

      private

      def resource
        @resource ||= Resources::Comment.new(client)
      end
    end
  end
end
