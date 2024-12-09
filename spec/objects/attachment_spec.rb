# frozen_string_literal: true

RSpec.describe YandexTracker::Objects::Attachment do
  it_behaves_like "tracker object" do
    let(:object_data) { attachment_data }
  end

  let(:client) { instance_double(YandexTracker::Client) }

  let(:attachment_data) { load_fixture("attachment") }

  subject { described_class.new(client, attachment_data) }

  it "responds to methods" do
    expect(subject).to respond_to(:download, :thumbnail)
  end
end
