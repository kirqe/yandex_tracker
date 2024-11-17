# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Attachment resource
    #
    class Attachment < Base
      def create(issue_id, file_path, filename: nil)
        file = prepare_file(file_path, filename: filename)
        post_multipart("issues/#{encode_path(issue_id)}/attachments", file: file)
      end

      def create_temp(file_path, filename: nil)
        file = prepare_file(file_path, filename: filename)
        post_multipart("attachments", file: file)
      end

      def list(issue_id)
        get("issues/#{encode_path(issue_id)}/attachments")
      end

      private

      def post_multipart(path, payload)
        handle_response client.multipart_conn.post(path, payload)
      end

      def prepare_file(file_path, filename: nil)
        Faraday::Multipart::FilePart.new(
          file_path,
          mime_type(file_path),
          filename || File.basename(file_path)
        )
      end

      def mime_type(file_path)
        case File.extname(file_path).downcase
        when ".jpg", ".jpeg" then "image/jpeg"
        when ".png" then "image/png"
        when ".gif" then "image/gif"
        when ".pdf" then "application/pdf"
        when ".doc", ".docx" then "application/msword"
        when ".xls", ".xlsx" then "application/vnd.ms-excel"
        else "application/octet-stream"
        end
      end
    end
  end
end
