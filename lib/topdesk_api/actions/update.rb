require 'byebug'

module TopdeskAPI
  module Actions
    class Update
      attr_reader :client, :id, :params, :url
      attr_accessor :errors

      def self.call(client, id, params, url)
        new(client, id, params, url).update
      end

      def initialize(client, id, params, url)
        @client = client
        @url = url
        @id = id
        @params = params
      end

      def update
        client.connection.put("tas/api/#{url}/id/#{id}") do |request|
          request.headers['Content-Type'] = 'application/json'
          request.body = params.to_json
        end
        true
      end
    end
  end
end
