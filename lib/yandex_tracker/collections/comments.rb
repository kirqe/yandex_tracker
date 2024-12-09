# frozen_string_literal: true

module YandexTracker
  module Collections
    #
    # Collections::Comments
    #
    class Comments < Base
      attr_reader :issue_id

      def initialize(client, issue_id)
        raise ArgumentError, "issue_id is required" if issue_id.nil?

        super(client)
        @resource = Resources::Comment.new(client)
        @issue_id = issue_id
      end

      def find(id)
        response = resource.find(issue_id, id)
        build_object(Objects::Comment, response, { issue_id: issue_id })
      end

      def create(**attributes)
        response = resource.create(issue_id, **attributes)
        build_object(Objects::Comment, response, { issue_id: issue_id })
      end

      def list(**params)
        response = resource.list(issue_id, **params)
        build_objects(Objects::Comment, response, { issue_id: issue_id })
      end

      def update(comment, **attributes)
        response = resource.update(issue_id, comment.id, **attributes)
        build_object(Objects::Comment, response, { issue_id: issue_id })
      end

      private

      attr_reader :resource
    end
  end
end
