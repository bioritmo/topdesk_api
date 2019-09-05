module TopdeskAPI
  module Resources
    class PersonExtraFieldA
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def find_by_name(name)
        person_extra_field_a(name)
      end

      private

      # this field is used for department
      def person_extra_field_a(name)
        @person_extra_field_a ||= TopdeskAPI::Actions::FindBy.call(
          client,
          'name',
          name,
          'personExtraFieldAEntries',
          'name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
