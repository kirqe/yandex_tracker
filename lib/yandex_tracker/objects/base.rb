# frozen_string_literal: true

module YandexTracker
  module Objects
    #
    # Objects::Base
    #
    class Base
      attr_reader :client, :data, :context

      def initialize(client, data, context = {})
        @client = client
        @data = data
        @context = context
        refresh_from(data)
      end

      def id
        data["id"]
      end

      def method_missing(name, *args)
        key = name.to_s
        return wrap_value(data[key]) if data.key?(key)

        super
      end

      def respond_to_missing?(name, include_private = false)
        data.key?(name.to_s) || super
      end

      # fetch full object from .self
      def expand
        return self unless data["self"]

        response = client.conn.get(data["self"]).body
        refresh_from(response)
      end

      protected

      def refresh_from(new_data)
        @data = new_data
        self
      end

      private

      def wrap_value(value)
        case value
        when Hash then wrap_hash(value)
        when Array then value.map { |v| wrap_value(v) }
        else value
        end
      end

      def wrap_hash(hash)
        return hash unless hash["self"]

        # Get the resource type from the last segment of the URL
        resource_type = hash["self"].split("/").last(2).first

        case resource_type
        when "users"     then Objects::User.new(client, hash)
        when "comments"  then Objects::Comment.new(client, hash, context)
        when "issues"    then Objects::Issue.new(client, hash)
        when "queues"    then Objects::Queue.new(client, hash)
        when "fields"    then Objects::Field.new(client, hash)
        when "workflows" then Objects::Workflow.new(client, hash)
        when "categories" then Objects::Category.new(client, hash)
        when "resolutions" then Objects::Resolution.new(client, hash)
        when "attachments" then Objects::Attachment.new(client, hash)
        when "localFields" then Objects::LocalField.new(client, hash)
        else hash
        end
      end

      def build_objects(klass, data)
        data.map { |item| klass.new(client, item, context) }
      end
    end
  end
end
