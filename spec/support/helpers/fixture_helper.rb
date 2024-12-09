# frozen_string_literal: true

module FixtureHelper
  def load_fixture(name)
    JSON.parse(File.read("spec/fixtures/api_responses/#{name}.json"))
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
