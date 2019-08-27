module TopdeskAPI
  module Actions
    class Create
      attr_reader :client, :params, :url
      attr_accessor :errors

      def self.call(client, params, url)
        new(client, params, url).create
      end

      def initialize(client, params, url)
        @client = client
        @url = url
        @params = params
      end

      def create
        client.connection.post("/tas/api/#{url}") do |request|
          request.headers['Content-Type'] = 'application/json'
          request.body = params.to_json
        end
        true
      end
    end
  end
end
