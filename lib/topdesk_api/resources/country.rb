module TopdeskAPI
  module Resources
    class Country
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def find_by_name(name)
        country(name)
      end

      private

      def country(name)
        @country ||= TopdeskAPI::Actions::FindBy.call(
          client,
          'name',
          name,
          'countries',
          'name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
