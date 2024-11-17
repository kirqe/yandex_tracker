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

    def users
      @users ||= Resources::User.new(self)
    end

    def queues
      @queues ||= Resources::Queue.new(self)
    end

    def issues
      @issues ||= Resources::Issue.new(self)
    end

    def comments
      @comments ||= Resources::Comment.new(self)
    end

    def attachments
      @attachments ||= Resources::Attachment.new(self)
    end

    private

    def make_client(request)
      Faraday.new(url: BASE_URL) do |f|
        f.request request
        f.response :json
        f.adapter Faraday.default_adapter
        f.headers.merge!(YandexTracker.configuration.additional_headers)
        f.request :authorization, "Bearer", -> { ensure_fresh_token }
      end
    end

    def ensure_fresh_token
      configuration = YandexTracker.configuration

      if configuration.can_refresh? && configuration.token_expired?
        if configuration.can_perform_oauth?
          YandexTracker::Auth.refresh_token
        else
          raise YandexTracker::Errors::AuthError,
                "Token expired and unable to refresh (missing refresh_token or OAuth credentials)"
        end
      end
      configuration.access_token
    end
  end
end
