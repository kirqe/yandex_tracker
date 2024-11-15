# frozen_string_literal: true

module YandexTracker
  #
  # Custom error classes and error formatting for the API client
  #
  module Errors
    class ApiError < StandardError; end
    class AuthError < ApiError; end
    class ConfigurationError < StandardError; end

    module_function

    def format_error(body)
      if body["error"] && body["error_description"]
        "#{body["error"]}: #{body["error_description"]}"
      else
        body.to_s
      end
    end
  end
end
