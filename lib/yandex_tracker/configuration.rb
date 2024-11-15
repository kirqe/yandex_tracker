# frozen_string_literal: true

module YandexTracker
  #
  # Handles API client configuration and validation
  #
  class Configuration
    attr_accessor :client_id, :client_secret, :timeout,
                  :cloud_org_id, :org_id,
                  :access_token, :refresh_token

    REQUIRED_ATTRIBUTES = %i[client_id client_secret].freeze
    REQUIRED_ONE_OF = [%i[cloud_org_id org_id]].freeze

    def initialize
      @timeout = 30
    end

    def validate!
      validate_required_attributes!
      validate_required_one_of!
    end

    def update_tokens(access_token:, refresh_token:, expires_in:)
      @access_token = access_token
      @refresh_token = refresh_token
      @token_expires_at = Time.now + expires_in
    end

    def token_expired?
      return true if @access_token.nil?
      return true if @token_expires_at.nil?

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

    private

    def validate_required_attributes!
      missing_attributes = REQUIRED_ATTRIBUTES.select { |attribute| send(attribute).nil? }

      return if missing_attributes.empty?

      raise YandexTracker::Errors::ConfigurationError,
            "Required configuration missing: #{missing_attributes.join(", ")}"
    end

    def validate_required_one_of!
      REQUIRED_ONE_OF.each do |attributes|
        next unless attributes.none? do |attribute|
          send(attribute)
        end

        raise YandexTracker::Errors::ConfigurationError,
              "Required configuration: one of #{attributes.join(", ")}"
      end
    end
  end
end
