# frozen_string_literal: true

require_relative "../resources/workflow"
require_relative "../objects/workflow"
require_relative "base"

module YandexTracker
  module Collections
    #
    # Collections::Workflows
    #
    class Workflows < Base
      def initialize(client)
        super
        @resource = Resources::Workflow.new(client)
      end

      def find(id)
        response = resource.find(id)
        build_object(Objects::Workflow, response)
      end

      def list(**params)
        response = resource.list(**params)
        build_objects(Objects::Workflow, response)
      end

      private

      attr_reader :resource
    end
  end
end
