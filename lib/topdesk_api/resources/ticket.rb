module TopdeskAPI
  module Resources
    class Ticket
      attr_reader :client, :params
      attr_accessor :action, :processing_status_id, :processing_status_name

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

      def update!
        params = {
          :action => action,
          :processingStatus => { :id => processing_status_id }
        }

        client.connection.put("/tas/api/incidents/id/#{id}") do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
      end

      def find_by_id!(params)
        id = params['id'] || params[:id]

        response = client.connection.get("/tas/api/incidents/id/#{id}") do |req|
          req.headers['Content-Type'] = 'application/json'
          yield req if block_given?
        end

        objectivize(response.body)
      end

      # Finds, returning nil if it fails
      def find_by_id(params)
        find_by_id!(params)
      rescue TopdeskAPI::Error::ClientError
        nil
      end

      # Find status id by name
      # and set to processing_status
      # example ticket.processing_status = New
      # returns id "123"
      # rubocop:disable DuplicateMethods
      def processing_status_id=(status)
        @processing_status_id = TopdeskAPI::Resources::TicketStatus.id(status)
      end
      # rubocop:enable DuplicateMethods

      private

      def objectivize(body)
        return if body == ''

        body.each do |name, value|
          singleton_class.class_eval { attr_accessor name }
          send("#{name}=", value)
        end
        self.processing_status_name = normalize_process_status(body)
        self
      end

      # Return status normalized by id
      def normalize_process_status(body)
        return if body['processingStatus'].nil?

        processing_status_id = body['processingStatus']['id']
        TopdeskAPI::Resources::TicketStatus.name(processing_status_id)
      end
    end
  end
end
