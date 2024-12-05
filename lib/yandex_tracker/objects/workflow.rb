# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Workflow
    #
    class Workflow < Base
      private

      def resource
        @resource ||= Resources::Workflow.new(client)
      end
    end
  end
end
