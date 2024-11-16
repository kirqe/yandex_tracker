# frozen_string_literal: true

require "ostruct"

module YandexTracker
  #
  # <Description>
  #
  module ResourceHandler
    def process_response(data)
      case data
      when Hash
        convert_hash_values(data)
      when Array
        data.map { |v| process_response(v) }
      else
        data
      end
    end

    private

    def convert_hash_values(hash)
      if reference?(hash)
        ResourceReference.new(hash)
      else
        OpenStruct.new(hash.transform_values { |v| process_response(v) })
      end
    end

    def reference?(hash)
      hash.is_a?(Hash) && (hash.key?("id") || hash.key?("key"))
    end
  end
end
