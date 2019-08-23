module TopdeskAPI
  module Resources
    class Department
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def find_by_name(name)
        department(name)
      end

      private

      def department(name)
        @department ||= TopdeskAPI::Actions::FindBy.call(
          client,
          'name',
          name,
          'departments',
          'name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
