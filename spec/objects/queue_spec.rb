# frozen_string_literal: true

RSpec.describe YandexTracker::Objects::Queue do
  it_behaves_like "tracker object" do
    let(:object_data) { queue_data }
  end

  let(:client) { instance_double(YandexTracker::Client) }

  let(:queue_data) { load_fixture("queue") }

  subject { described_class.new(client, queue_data) }

  it "wraps nested objects" do
    expect(subject.lead).to be_a(YandexTracker::Objects::User)
  end

  it "provides direct access to raw data" do
    expect(subject.name).to eq(queue_data["name"])
    expect(subject.lead.data).to eq(queue_data["lead"])
  end

  it "responds to methods" do
    expect(subject).to respond_to(:issues, :local_fields)
  end
end
