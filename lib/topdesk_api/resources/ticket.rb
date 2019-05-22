module TopdeskAPI
  module Resources
    class Ticket
      attr_reader :client, :params

      def initialize(client, params)
        @client = client
        @params = params
      end

      def create(params)
        client.connection.post('/tas/api/incidents/') do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
      end

      def find_by_id(id)
        client.connection.get("/tas/api/incidents/id/#{id}") do |req|
          req.headers['Content-Type'] = 'application/json'
        end
      end
    end
  end
end
