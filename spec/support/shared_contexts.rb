# frozen_string_literal: true

RSpec.shared_context "with api stubs" do
  before do
    YandexTracker.configure do |config|
      config.access_token = "test_token"
      config.org_id = "test_org"
    end
  end
end
