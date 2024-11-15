# frozen_string_literal: true

RSpec.describe YandexTracker::Auth do
  let(:client_id) { "test_client_id" }
  let(:client_secret) { "test_client_secret" }
  let(:mock_response) do
    {
      "access_token" => "new_access_token",
      "refresh_token" => "new_refresh_token",
      "expires_in" => 3600
    }
  end

  before do
    YandexTracker.configure do |config|
      config.client_id = client_id
      config.client_secret = client_secret
    end
  end

  describe ".exchange_code" do
    it "exchanges authorization code for tokens" do
      stub_auth_request(
        grant_type: "authorization_code",
        code: "test_code"
      )

      response = described_class.exchange_code("test_code")
      expect(response).to eq(mock_response)
    end
  end

  describe ".refresh_token" do
    before do
      YandexTracker.configuration.refresh_token = "old_refresh_token"
    end

    it "refreshes the access token" do
      stub_auth_request(
        grant_type: "refresh_token",
        refresh_token: "old_refresh_token"
      )

      response = described_class.refresh_token
      expect(response).to eq(mock_response)
      expect(YandexTracker.configuration.access_token).to eq("new_access_token")
      expect(YandexTracker.configuration.refresh_token).to eq("new_refresh_token")
    end
  end

  describe ".basic_auth" do
    it "generates correct Basic Auth header" do
      expected = Base64.strict_encode64("#{client_id}:#{client_secret}")
      expect(described_class.basic_auth).to eq(expected)
    end
  end

  describe ".handle_response" do
    let(:success_response) { double(status: 200, body: mock_response) }
    let(:error_response) { double(status: 401, body: { "error" => "invalid_token" }) }

    it "returns response body for successful requests" do
      expect(described_class.handle_response(success_response)).to eq(mock_response)
    end

    it "raises AuthError for failed requests" do
      expect do
        described_class.handle_response(error_response)
      end.to raise_error(YandexTracker::Errors::AuthError)
    end
  end

  private

  def stub_auth_request(params)
    stub_request(:post, "#{YandexTracker::Auth::AUTH_URL}/token")
      .with(body: params, headers: auth_headers)
      .to_return(success_response)
  end

  def auth_headers
    {
      "Authorization" => "Basic #{described_class.basic_auth}",
      "Content-Type" => "application/x-www-form-urlencoded"
    }
  end

  def success_response
    {
      status: 200,
      body: mock_response.to_json,
      headers: { "Content-Type" => "application/json" }
    }
  end
end
