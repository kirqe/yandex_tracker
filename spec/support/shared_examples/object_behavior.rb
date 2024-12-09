# frozen_string_literal: true

RSpec.shared_examples "tracker object" do
  it "provides access to raw data" do
    expect(subject.data).to eq(object_data)
  end

  it "handles method_missing for attributes" do
    expect(subject.id).to eq(object_data["id"])
  end

  it "responds to methods" do
    expect(subject).to respond_to(:expand)
  end
end
