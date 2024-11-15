# frozen_string_literal: true

RSpec.describe YandexTracker::Configuration do
  let(:config) { described_class.new }
  let(:valid_attributes) do
    {
      client_id: "test_client_id",
      client_secret: "test_client_secret",
      cloud_org_id: "test_cloud_org_id"
    }
  end

  describe "#validate!" do
    it "passes with all required attributes" do
      config.client_id = valid_attributes[:client_id]
      config.client_secret = valid_attributes[:client_secret]
      config.cloud_org_id = valid_attributes[:cloud_org_id]

      expect { config.validate! }.not_to raise_error
    end

    it "raises error when client_id is missing" do
      config.client_secret = valid_attributes[:client_secret]
      config.cloud_org_id = valid_attributes[:cloud_org_id]

      expect { config.validate! }.to raise_error(
        YandexTracker::Errors::ConfigurationError,
        /Required configuration missing: client_id/
      )
    end

    it "raises error when both org_id and cloud_org_id are missing" do
      config.client_id = valid_attributes[:client_id]
      config.client_secret = valid_attributes[:client_secret]

      expect { config.validate! }.to raise_error(
        YandexTracker::Errors::ConfigurationError,
        /Required configuration: one of cloud_org_id, org_id/
      )
    end
  end

  describe "#update_tokens" do
    let(:token_data) do
      {
        access_token: "new_access_token",
        refresh_token: "new_refresh_token",
        expires_in: 3600
      }
    end

    it "updates tokens and sets expiration" do
      config.update_tokens(**token_data)

      expect(config.access_token).to eq("new_access_token")
      expect(config.refresh_token).to eq("new_refresh_token")
      expect(config.token_expired?).to eq(false)
    end
  end
end
