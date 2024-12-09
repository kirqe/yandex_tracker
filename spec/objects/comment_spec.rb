# frozen_string_literal: true

RSpec.describe YandexTracker::Objects::Comment do
  it_behaves_like "tracker object" do
    let(:object_data) { comment_data }
  end

  let(:client) { instance_double(YandexTracker::Client) }

  let(:comment_data) { load_fixture("comment") }

  subject { described_class.new(client, comment_data) }

  it "wraps nested objects" do
    expect(subject.createdBy).to be_a(YandexTracker::Objects::User)
    expect(subject.attachments).to be_a(YandexTracker::Collections::Attachments)
  end

  it "provides direct access to raw data" do
    expect(subject.text).to eq(comment_data["text"])
    expect(subject.createdBy.data).to eq(comment_data["createdBy"])
  end

  it "responds to methods" do
    expect(subject).to respond_to(:attachments)
  end
end
