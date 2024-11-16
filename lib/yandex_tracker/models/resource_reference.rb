# frozen_string_literal: true

module YandexTracker
  module Models
    #
    # <Description>
    #
    class ResourceReference < Base
      def to_s
        @display || @key || @id || ""
      end

      def url
        @self
      end

      def identifier
        @key || @id
      end
    end
  end
end
