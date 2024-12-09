# frozen_string_literal: true

RSpec.describe YandexTracker::Objects::Field do
  it_behaves_like "tracker object" do
    let(:object_data) { field_data }
  end

  let(:client) { instance_double(YandexTracker::Client) }

  let(:field_data) { load_fixture("field") }

  subject { described_class.new(client, field_data) }
end
