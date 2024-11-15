# frozen_string_literal: true

require_relative "yandex_tracker/version"
require_relative "yandex_tracker/errors"
require_relative "yandex_tracker/configuration"
require_relative "yandex_tracker/auth"
require_relative "yandex_tracker/client"

#
# Ruby wrapper for the YandexTracker REST API
#
module YandexTracker
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.client
    @client ||= Client.new
  end
end
