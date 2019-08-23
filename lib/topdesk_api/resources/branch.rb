module TopdeskAPI
  module Resources
    class Branch
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def find_by_name(name)
        branch(name)
      end

      private

      def branch(name)
        @branch ||= TopdeskAPI::Actions::FindBy.call(
          client,
          'name',
          name,
          'branches',
          'name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
