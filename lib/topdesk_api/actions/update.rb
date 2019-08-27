require 'byebug'

module TopdeskAPI
  module Actions
    class Update
      attr_reader :client, :id, :params, :url, :details
      attr_accessor :errors

      def self.call(client, id, params, url, details = nil)
        new(client, id, params, url, details).update
      end

      def initialize(client, id, params, url, details)
        @client = client
        @url = url
        @id = id
        @params = params
        @details = details
      end

      def update
        client.connection.put("tas/api/#{url}/id/#{id}/#{details}") do |request|
          request.headers['Content-Type'] = 'application/json'
          request.body = params.to_json
        end
        true
      end
    end
  end
end
