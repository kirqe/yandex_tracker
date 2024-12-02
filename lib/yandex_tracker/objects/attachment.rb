# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Attachment
    #
    class Attachment < Base
      def download
        resource.get(data["content"])
      end

      def thumbnail
        resource.get(data["thumbnail"])
      end

      private

      def resource
        @resource ||= Resources::Attachment.new(client)
      end
    end
  end
end
