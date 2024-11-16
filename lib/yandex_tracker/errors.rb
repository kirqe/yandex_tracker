# frozen_string_literal: true

module YandexTracker
  #
  # Custom error classes and error formatting for the API client
  #
  module Errors
    class ApiError < StandardError; end
    class AuthError < ApiError; end
    class Unauthorized < ApiError; end
    class NotFound < ApiError; end
    class TimeoutError < ApiError; end
    class ConnectionError < ApiError; end
    class ConfigurationError < StandardError; end

    module_function

    def format_message(body)
      return body.to_s unless body.is_a?(Hash)

      body["errorMessages"]&.join(", ") || body["message"] || body.to_s
    end
  end
end
