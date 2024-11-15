# frozen_string_literal: true

require "base64"
require "faraday"

module YandexTracker
  #
  # Handles OAuth authentication flow and token management
  #
  class Auth
    AUTH_URL = "https://oauth.yandex.ru"

    class << self
      def exchange_code(code)
        response = auth_request(
          grant_type: "authorization_code",
          code: code
        )

        update_configuration(response)
      end

      def refresh_token
        response = auth_request(
          grant_type: "refresh_token",
          refresh_token: YandexTracker.configuration.refresh_token
        )

        update_configuration(response)
      end

      def auth_request(params)
        conn = Faraday.new(url: AUTH_URL) do |f|
          f.request :url_encoded
          f.response :json
          f.adapter Faraday.default_adapter
          f.headers["Content-Type"] = "application/x-www-form-urlencoded"
          f.headers["Authorization"] = "Basic #{basic_auth}"
        end

        response = conn.post("/token", params)
        handle_response(response)
      end

      def basic_auth
        credentials = "#{YandexTracker.configuration.client_id}:#{YandexTracker.configuration.client_secret}"
        Base64.strict_encode64(credentials)
      end

      def handle_response(response)
        case response.status
        when 200..299
          response.body
        else
          raise YandexTracker::Errors::AuthError, YandexTracker::Errors.format_error(response.body)
        end
      end

      def update_configuration(response)
        YandexTracker.configuration.update_tokens(
          access_token: response["access_token"],
          refresh_token: response["refresh_token"],
          expires_in: response["expires_in"]
        )

        response
      end
    end
  end
end
