# frozen_string_literal: true

require_relative "base"

module YandexTracker
  module Resources
    #
    # Resources::Attachment
    #
    class Attachment < Base
      # Create unattached file
      def create(file, **attributes)
        upload("attachments", file, attributes)
      end

      # Upload file directly to issue
      def create_for_issue(issue_id, file, **attributes)
        upload("issues/#{issue_id}/attachments", file, attributes)
      end

      # Upload file directly to comment
      def create_for_comment(issue_id, comment_id, file, **attributes)
        upload("issues/#{issue_id}/comments/#{comment_id}/attachments", file, attributes)
      end

      def find(id)
        get("attachments/#{id}")
      end

      def list(issue_id, **params)
        get("issues/#{issue_id}/attachments", params)
      end

      private

      def upload(path, file, attributes)
        form = {
          file: Faraday::Multipart::FilePart.new(
            file.path,
            mime_type(file),
            File.basename(file)
          )
        }.merge(attributes)

        handle_response client.multipart_conn.post(path, form)
      end

      def mime_type(file)
        return file.content_type if file.respond_to?(:content_type)

        require "mime/types"
        MIME::Types.type_for(file.path).first&.content_type || "application/octet-stream"
      end
    end
  end
end
