# frozen_string_literal: true

require "base64"
require "faraday"

module YandexTracker
  #
  # Handles OAuth authentication flow and token management
  #
  class Auth
    AUTH_URL = "https://oauth.yandex.ru/token"

    class << self
      def exchange_code(code)
        raise ArgumentError, "code is required" if code.nil? || code.empty?

        response = make_request(grant_type: "authorization_code", code: code)
        update_configuration(response)
        response
      end

      def refresh_token
        validate_oauth_config!
        refresh_token = YandexTracker.configuration.refresh_token
        raise ArgumentError, "refresh_token is required" if refresh_token.nil? || refresh_token.empty?

        response = make_request(grant_type: "refresh_token", refresh_token: refresh_token)
        update_configuration(response)
        response
      end

      private

      def validate_oauth_config!
        config = YandexTracker.configuration

        raise Errors::AuthError, "client_id is required" if config.client_id.nil? || config.client_id.empty?
        raise Errors::AuthError, "client_secret is required" if config.client_secret.nil? || config.client_secret.empty?
      end

      def make_request(params)
        response = connection.post("", params)
        handle_response(response)
      rescue Faraday::Error => e
        raise Errors::AuthError, "Authentication failed: #{e.message}"
      end

      def connection
        Faraday.new(url: AUTH_URL) do |f|
          f.request :url_encoded
          f.response :json
          f.headers["Authorization"] = "Basic #{basic_auth}"
        end
      end

      def basic_auth
        credentials = "#{YandexTracker.configuration.client_id}:#{YandexTracker.configuration.client_secret}"
        Base64.strict_encode64(credentials)
      end

      def handle_response(response)
        return response.body if response.success?

        raise Errors::AuthError, Errors.format_message(response.body)
      end

      def update_configuration(response_body)
        YandexTracker.configuration.update_tokens(
          access_token: response_body["access_token"],
          refresh_token: response_body["refresh_token"],
          expires_in: response_body["expires_in"]
        )
      end
    end
  end
end
