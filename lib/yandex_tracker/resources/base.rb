# frozen_string_literal: true

require "uri"
require_relative "../resource_handler"

module YandexTracker
  module Resources
    #
    # Base Resource
    #
    class Base
      include ResourceHandler

      attr_reader :client

      def initialize(client)
        @client = client
      end

      def get(path, params = {})
        handle_response client.conn.get(path, params)
      end

      def post(path, body = {})
        handle_response client.conn.post(path, body)
      end

      def put(path, body = {})
        handle_response client.conn.put(path, body)
      end

      def delete(path, params = {})
        handle_response client.conn.delete(path, params)
      end

      def handle_response(response)
        return process_response(response.body) if response.success?

        handle_error_response(response)
      rescue Faraday::TimeoutError
        raise Errors::TimeoutError, "Request timed out"
      rescue Faraday::ConnectionFailed => e
        raise Errors::ConnectionError, "Connection failed: #{e.message}"
      end

      def handle_error_response(response)
        case response.status
        when 401, 403 then raise Errors::Unauthorized, Errors.format_message(response.body)
        when 404 then raise Errors::NotFound, Errors.format_message(response.body)
        else raise Errors::ApiError, Errors.format_message(response.body)
        end
      end

      def encode_path(path)
        URI.encode_www_form_component(path)
      rescue URI::InvalidURIError => e
        raise Errors::ApiError, "Invalid path: #{e.message}"
      end
    end
  end
end
