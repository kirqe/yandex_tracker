# frozen_string_literal: true

RSpec.describe YandexTracker::Objects::Issue do
  it_behaves_like "tracker object" do
    let(:object_data) { issue_data }
  end

  let(:client) { instance_double(YandexTracker::Client) }

  let(:issue_data) { load_fixture("issue") }

  subject { described_class.new(client, issue_data) }

  it "wraps nested objects" do
    expect(subject.createdBy).to be_a(YandexTracker::Objects::User)
  end

  it "provides direct access to raw data" do
    expect(subject.summary).to eq(issue_data["summary"])
    expect(subject.createdBy.data).to eq(issue_data["createdBy"])
  end

  it "responds to methods" do
    expect(subject).to respond_to(:comments, :attachments)
  end
end
