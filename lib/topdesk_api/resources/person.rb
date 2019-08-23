module TopdeskAPI
  module Resources
    class Person
      attr_reader :client, :ssp_login_name
      attr_accessor :errors

      def initialize(client, ssp_login_name)
        @client = client
        @ssp_login_name = ssp_login_name
      end

      def update(id, params)
        raise ArgumentError, "Please give the id" if id.nil? || id.empty?

        TopdeskAPI::Actions::Update.call(
          client,
          id,
          params,
          'persons'
        )

      rescue TopdeskAPI::Error::RecordInvalid => e
        @errors = e.errors
        false
      rescue TopdeskAPI::Error::ClientError
        false
      end

      def create(params)
        TopdeskAPI::Actions::Create.call(
          client,
          params,
          'persons'
        )

      rescue TopdeskAPI::Error::RecordInvalid => e
        @errors = e.errors
        false
      rescue TopdeskAPI::Error::ClientError
        false
      end

      def find_by(ssp_login_name)
        TopdeskAPI::Actions::FindBy.call(
          client,
          'tasLoginName',
          ssp_login_name,
          'persons',
          'ssp_login_name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
