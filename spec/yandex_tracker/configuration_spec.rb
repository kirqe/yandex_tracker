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
    context "with access token" do
      it "passes with access_token and org_id" do
        config.access_token = "test_token"
        config.org_id = "test_org_id"
        expect { config.validate! }.not_to raise_error
      end

      it "passes with access_token and cloud_org_id" do
        config.access_token = "test_token"
        config.cloud_org_id = "test_cloud_org_id"
        expect { config.validate! }.not_to raise_error
      end
    end

    context "with OAuth" do
      it "passes with client credentials and org_id" do
        config.client_id = "test_client_id"
        config.client_secret = "test_secret"
        config.org_id = "test_org_id"
        expect { config.validate! }.not_to raise_error
      end
    end

    it "raises error when no auth method provided" do
      config.org_id = "test_org_id"
      expect { config.validate! }.to raise_error(
        YandexTracker::Errors::ConfigurationError,
        "Either access_token or (client_id + client_secret) are required"
      )
    end

    it "raises error when org identification missing" do
      config.access_token = "test_token"
      expect { config.validate! }.to raise_error(
        YandexTracker::Errors::ConfigurationError,
        "Required configuration missing: one of cloud_org_id, org_id"
      )
    end
  end

  describe "#token_expired?" do
    it "returns false when token_expires_at not set" do
      expect(config.token_expired?).to be false
    end

    it "returns false when token is not expired" do
      config.update_tokens(
        access_token: "token",
        refresh_token: "refresh",
        expires_in: 3600
      )
      expect(config.token_expired?).to be false
    end

    it "returns true when token is expired" do
      config.update_tokens(
        access_token: "token",
        refresh_token: "refresh",
        expires_in: -1
      )
      expect(config.token_expired?).to be true
    end

    it "returns false with just access_token (no expiry tracking)" do
      config.access_token = "token"
      expect(config.token_expired?).to be false
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
