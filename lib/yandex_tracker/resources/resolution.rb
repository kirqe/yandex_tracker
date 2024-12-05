# frozen_string_literal: true

module YandexTracker
  module Resources
    #
    # Resources::Resolution
    #
    class Resolution < Base
      def list(**params)
        get("resolutions", params)
      end

      def find(id)
        get("resolutions/#{id}")
      end
    end
  end
end
