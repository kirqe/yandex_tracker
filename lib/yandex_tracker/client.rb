# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "faraday/retry"

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
      Collections::Users.new(self)
    end

    def queues
      Collections::Queues.new(self)
    end

    def issues(queue: nil)
      Collections::Issues.new(self, queue)
    end

    def comments(issue: nil)
      Collections::Comments.new(self, issue)
    end

    def attachments(issue: nil)
      Collections::Attachments.new(self, issue)
    end

    def workflows
      Collections::Workflows.new(self)
    end

    def resolutions
      Collections::Resolutions.new(self)
    end

    def fields
      Collections::Fields.new(self)
    end

    def categories
      Collections::Categories.new(self)
    end

    private

    def make_client(request)
      Faraday.new(url: BASE_URL) do |f|
        f.request request
        f.response :json
        f.request :retry, { max: 3, retry_statuses: [401, 409, 500, 502, 503, 504] }
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
