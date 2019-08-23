# require 'topdesk_api/error'

module TopdeskAPI
  module Resources
    class Operator
      attr_reader :client, :params
      attr_accessor :errors

      def initialize(client, params)
        @client = client
        @params = params
      end

      def update(id, params)
        raise ArgumentError, "Please give the id" if id.nil? || id.empty?

        TopdeskAPI::Actions::Update.call(client, id, params, 'operators')

      rescue TopdeskAPI::Error::RecordInvalid => e
        @errors = e.errors
        false
      rescue TopdeskAPI::Error::ClientError
        false
      end

      def find_by(topdesk_login_name)
        TopdeskAPI::Actions::FindBy.call(
          client,
          'loginName',
          topdesk_login_name,
          'operators',
          'topdesk_login_name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
