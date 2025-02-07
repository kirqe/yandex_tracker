# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Issue
    #
    class Issue < Base
      def comments
        @comments ||= Collections::Comments.new(client, id)
      end

      def attachments
        if data["attachments"]
          build_objects(Objects::Attachment, data["attachments"])
        else
          Collections::Attachments.new(client, id)
        end
      end

      def update(**attributes)
        response = resource.update(id, attributes)
        refresh_from(response)
      end

      def transition(transition_id, **attributes)
        resource.transition(id, transition_id, **attributes)
      end

      private

      def resource
        @resource ||= Resources::Issue.new(client)
      end
    end
  end
end
