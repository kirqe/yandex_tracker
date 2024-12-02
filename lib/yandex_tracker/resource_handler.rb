# frozen_string_literal: true

module YandexTracker
  #
  # ResourceHandler
  #
  module ResourceHandler
    def process_response(data)
      case data
      when Hash then data.transform_values { |v| process_response(v) }
      when Array then data.map { |v| process_response(v) }
      else data
      end
    end
  end
end
