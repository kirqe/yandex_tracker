# frozen_string_literal: true

require "faraday"
require "faraday/multipart"

module YandexTracker
  #
  # API client
  #
  class Client
    BASE_URL = "https://api.tracker.yandex.net/v2"

    attr_reader :conn, :multipart_conn

    def initialize
      YandexTracker.configuration.validate!
      setup_connections
    end

    def setup_connections
      @conn = make_client(:json)
      @multipart_conn = make_client(:multipart)
    end

    private

    def make_client(request)
      Faraday.new(url: BASE_URL) do |f|
        f.request request
        f.response :json
        f.adapter Faraday.default_adapter
        f.headers.merge!(YandexTracker.configuration.additional_headers)
        f.options.timeout = YandexTracker.configuration.timeout
        f.request :authorization, "Bearer", -> { ensure_fresh_token }
      end
    end

    def ensure_fresh_token
      YandexTracker::Auth.refresh_token if YandexTracker.configuration.token_expired?
      YandexTracker.configuration.access_token
    end
  end
end
