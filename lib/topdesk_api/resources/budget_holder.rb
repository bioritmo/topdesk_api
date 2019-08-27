module TopdeskAPI
  module Resources
    class BudgetHolder
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def find_by_name(name)
        budget_holder(name)
      end

      private

      def budget_holder(name)
        @budget_holder ||= TopdeskAPI::Actions::FindBy.call(
          client,
          'name',
          name,
          'budgetholders',
          'name'
        )
      rescue TopdeskAPI::Error::RecordNotFound
        nil
      end
    end
  end
end
