# frozen_string_literal: true

# Dir[File.join(__dir__, "yandex_tracker/**/*.rb")].sort.each { |f| require f }

require_relative "yandex_tracker/version"
require_relative "yandex_tracker/errors"
require_relative "yandex_tracker/objects/base"
require_relative "yandex_tracker/collections/base"

require_relative "yandex_tracker/configuration"
require_relative "yandex_tracker/auth"
require_relative "yandex_tracker/client"
require_relative "yandex_tracker/resources/base"
require_relative "yandex_tracker/resources/user"
require_relative "yandex_tracker/resources/queue"
require_relative "yandex_tracker/resources/issue"
require_relative "yandex_tracker/resources/comment"
require_relative "yandex_tracker/resources/attachment"
require_relative "yandex_tracker/resources/workflow"
require_relative "yandex_tracker/resources/resolution"
require_relative "yandex_tracker/resources/field"
require_relative "yandex_tracker/resources/local_field"
require_relative "yandex_tracker/resources/category"

require_relative "yandex_tracker/collections/queues"
require_relative "yandex_tracker/collections/issues"
require_relative "yandex_tracker/collections/comments"
require_relative "yandex_tracker/collections/attachments"
require_relative "yandex_tracker/collections/users"
require_relative "yandex_tracker/collections/workflows"
require_relative "yandex_tracker/collections/resolutions"
require_relative "yandex_tracker/collections/fields"
require_relative "yandex_tracker/collections/local_fields"
require_relative "yandex_tracker/collections/categories"

require_relative "yandex_tracker/objects/queue"
require_relative "yandex_tracker/objects/issue"
require_relative "yandex_tracker/objects/comment"
require_relative "yandex_tracker/objects/attachment"
require_relative "yandex_tracker/objects/user"
require_relative "yandex_tracker/objects/workflow"
require_relative "yandex_tracker/objects/resolution"
require_relative "yandex_tracker/objects/field"
require_relative "yandex_tracker/objects/local_field"
require_relative "yandex_tracker/objects/category"

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
