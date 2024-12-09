# frozen_string_literal: true

module YandexTracker
  module Collections
    #
    # Collections::Attachments
    #
    class Attachments < Base
      def initialize(client, issue_id = nil, comment_id = nil)
        super(client)
        @resource = Resources::Attachment.new(client)
        @issue_id = issue_id
        @comment_id = comment_id
      end

      def create(file, **attributes)
        response = if comment_id
                     resource.create_for_comment(issue_id, comment_id, file, **attributes)
                   elsif issue_id
                     resource.create_for_issue(issue_id, file, **attributes)
                   else
                     resource.create(file, **attributes) # Create unattached file
                   end
        build_object(Objects::Attachment, response, { issue_id: issue_id })
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Attachment, response, { issue_id: issue_id })
      end

      def list(**params)
        params = params.merge(issue: issue_id) if issue_id
        response = resource.list(issue_id, **params)
        build_objects(Objects::Attachment, response, { issue_id: issue_id })
      end

      private

      attr_reader :resource, :issue_id, :comment_id
    end
  end
end
