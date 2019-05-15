module TopdeskAPI
  module Resources
    class Tickets
      attr_reader :client, :params

      def initialize(client, params)
        @client = client
        @params = params
      end

      def create
        client.connection.post('/tas/api/incidents/') do |req|
          req.body = params.to_json
        end
      end
    end
  end
end
