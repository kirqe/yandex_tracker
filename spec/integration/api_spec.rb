# frozen_string_literal: true

require_relative "../support/shared_contexts"

RSpec.describe "API Integration" do
  include_context "with api stubs"

  let(:client) { YandexTracker::Client.new }

  let(:urls) do
    {
      queue: "https://api.tracker.yandex.net/v2/queues",
      queue_issues: "https://api.tracker.yandex.net/v2/issues",
      issue: "https://api.tracker.yandex.net/v2/issues",
      issue_comments: "https://api.tracker.yandex.net/v2/issues/123456789/comments",
      issue_attachments: "https://api.tracker.yandex.net/v2/issues/123456789/attachments",
      issue_close_transition: "https://api.tracker.yandex.net/v2/issues/123456789/transitions/close/_execute"
    }
  end

  describe "simple workflow" do
    it "manages tracker entities" do
      # CREATE QUEUE
      stub_request(:post, urls[:queue])
        .with(body: hash_including(name: "TEST"))
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: load_fixture("queue").to_json
        )

      # CREATE ISSUE
      stub_request(:post, urls[:issue])
        .with(body: hash_including(summary: "Test Issue", queue: "TEST"))
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: load_fixture("issue").to_json
        )

      # CREATE COMMENT
      stub_request(:post, urls[:issue_comments])
        .with(body: hash_including(text: "Test Comment"))
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: load_fixture("comment").to_json
        )

      # CREATE ATTACHMENT
      stub_request(:post, urls[:issue_attachments])
        .with { |req| req.headers["Content-Type"] =~ %r{multipart/form-data} }
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: load_fixture("attachment").to_json
        )

      # LIST QUEUE ISSUES
      stub_request(:get, urls[:queue_issues])
        .with(query: { queue: "123456789" })
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: [load_fixture("issue")].to_json
        )

      # LIST ISSUE COMMENTS
      stub_request(:get, urls[:issue_comments])
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: [load_fixture("comment")].to_json
        )

      # CREATE TRANSITION
      stub_request(:post, urls[:issue_close_transition])
        .with(body: hash_including(resolution: "fixed"))
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: [{ id: "reopen", to: { key: "open" } }].to_json
        )

      # Test workflow
      queue = client.queues.create(name: "TEST")
      expect(queue.id).to eq("123456789")

      issue = client.issues.create(summary: "Test Issue", queue: queue.key)
      expect(issue.id).to eq("123456789")

      comment = issue.comments.create(text: "Test Comment")
      expect(comment.id).to eq("123456789")

      attachment = issue.attachments.create(File.open("spec/support/test.png"))
      expect(attachment.id).to eq("123456789")

      # Test listing
      issues = queue.issues.list
      expect(issues.first.id).to eq("123456789")

      comments = issue.comments.list
      expect(comments.first.id).to eq("123456789")

      # Test transition
      transitions = issue.transition("close", resolution: "fixed")
      expect(transitions).to be_an(Array)
      expect(transitions.first["id"]).to eq("reopen")
    end
  end
end
