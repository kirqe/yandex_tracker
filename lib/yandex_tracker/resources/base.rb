# frozen_string_literal: true

require "uri"
require_relative "../resource_handler"

module YandexTracker
  module Resources
    #
    # Resources::Base
    #
    class Base
      include ResourceHandler

      attr_reader :client

      def initialize(client)
        @client = client
      end

      def get(path, params = {}, query_params = {})
        handle_response client.conn.get(prepare_path(path, query_params), params)
      end

      def post(path, body = {}, query_params = {})
        handle_response client.conn.post(prepare_path(path, query_params), body)
      end

      def put(path, body = {}, query_params = {})
        handle_response client.conn.put(prepare_path(path, query_params), body)
      end

      def patch(path, body = {}, query_params = {})
        handle_response client.conn.patch(prepare_path(path, query_params), body)
      end

      def delete(path, params = {}, query_params = {})
        handle_response client.conn.delete(prepare_path(path, query_params), params)
      end

      private

      def handle_response(response)
        puts response.env.url
        return process_response(response.body) if response.success?

        handle_error_response(response)
      rescue Faraday::TimeoutError
        raise Errors::TimeoutError, "Request timed out"
      rescue Faraday::ConnectionFailed => e
        raise Errors::ConnectionError, "Connection failed: #{e.message}"
      end

      def handle_error_response(response)
        puts response.body
        case response.status
        when 401, 403 then raise Errors::Unauthorized, Errors.format_message(response.body)
        when 404 then raise Errors::NotFound, Errors.format_message(response.body)
        else raise Errors::ApiError, Errors.format_message(response.body)
        end
      end

      def encode_path(path)
        URI.encode_www_form_component(path.to_s)
      rescue URI::InvalidURIError => e
        raise Errors::ApiError, "Invalid path: #{e.message}"
      end

      def prepare_path(path, query_params = {})
        path = encode_path(path)
        path = "#{path}?#{URI.encode_www_form(query_params)}" unless query_params.empty?
        path
      end
    end
  end
end
