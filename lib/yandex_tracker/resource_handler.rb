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
      processed = hash.transform_values { |v| process_response(v) }
      OpenStruct.new(processed)
    end
  end
end
