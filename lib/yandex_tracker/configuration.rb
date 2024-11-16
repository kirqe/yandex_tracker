# frozen_string_literal: true

module YandexTracker
  #
  # Handles API client configuration and validation
  #
  class Configuration
    attr_accessor :client_id, :client_secret,
                  :cloud_org_id, :org_id,
                  :access_token, :refresh_token

    def validate!
      validate_org_configuration!
      validate_auth_configuration!
    end

    def update_tokens(access_token:, refresh_token:, expires_in:)
      @access_token = access_token
      @refresh_token = refresh_token
      @token_expires_at = Time.now + expires_in
    end

    def token_expired?
      return false unless @token_expires_at

      Time.now >= @token_expires_at
    end

    def can_refresh?
      !@refresh_token.nil?
    end

    def additional_headers
      headers = {}
      headers["X-Cloud-Org-ID"] = cloud_org_id if cloud_org_id
      headers["X-Org-Id"] = org_id if org_id && !cloud_org_id
      headers
    end

    def can_perform_oauth?
      client_id && client_secret
    end

    private

    def validate_org_configuration!
      return if cloud_org_id || org_id

      raise YandexTracker::Errors::ConfigurationError,
            "Required configuration missing: one of cloud_org_id, org_id"
    end

    def validate_auth_configuration!
      return if access_token || (client_id && client_secret)

      raise YandexTracker::Errors::ConfigurationError,
            "Either access_token or (client_id + client_secret) are required"
    end
  end
end
