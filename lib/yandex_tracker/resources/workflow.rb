# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Workflow
    #
    class Workflow < Base
      def list(**params)
        get("workflows", params)
      end

      def find(id)
        get("workflows/#{id}")
      end
    end
  end
end
