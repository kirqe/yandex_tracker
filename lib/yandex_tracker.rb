# frozen_string_literal: true

require_relative "yandex_tracker/version"
require_relative "yandex_tracker/errors"
require_relative "yandex_tracker/objects/base"
require_relative "yandex_tracker/collections/base"

require_relative "yandex_tracker/configuration"
require_relative "yandex_tracker/auth"
require_relative "yandex_tracker/resource_handler"
require_relative "yandex_tracker/client"
require_relative "yandex_tracker/resources/base"
require_relative "yandex_tracker/resources/user"
require_relative "yandex_tracker/resources/queue"
require_relative "yandex_tracker/resources/issue"
require_relative "yandex_tracker/resources/comment"
require_relative "yandex_tracker/resources/attachment"

require_relative "yandex_tracker/collections/queues"
require_relative "yandex_tracker/collections/issues"
require_relative "yandex_tracker/collections/comments"
require_relative "yandex_tracker/collections/attachments"
require_relative "yandex_tracker/collections/users"

require_relative "yandex_tracker/objects/queue"
require_relative "yandex_tracker/objects/issue"
require_relative "yandex_tracker/objects/comment"
require_relative "yandex_tracker/objects/attachment"
require_relative "yandex_tracker/objects/user"

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
