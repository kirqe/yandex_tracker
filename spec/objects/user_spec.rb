# frozen_string_literal: true

RSpec.describe YandexTracker::Objects::User do
  it_behaves_like "tracker object" do
    let(:object_data) { user_data }
  end

  let(:client) { instance_double(YandexTracker::Client) }

  let(:user_data) { load_fixture("user") }

  subject { described_class.new(client, user_data) }
end
