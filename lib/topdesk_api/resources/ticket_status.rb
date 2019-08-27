# This is necessary due to Status on topdesk is a relationship
# In case the name was changed the id will be HARDCODED, so it doesn't matter

module TopdeskAPI
  module Resources
    class TicketStatus
      STATUS = {
        NEW: 'a3e2ad64-16e2-4fe3-9c66-9e50ad9c4d69',
        OPEN: '2817418e-5afc-4a8e-b2e4-7e4ff104e095',
        PENDING: 'dc36014f-d7c2-4f84-a23f-129ed93ee5d5',
        HOLDING: '2bc54ec5-fc66-4475-be58-03dc663a3c70',
        RESOLVED: '2f8c81f5-7f6c-4fad-b309-08b235bde18d',
        CLOSED: '9260dea6-e65c-4455-9f00-197fdb3383ce'
      }.freeze

      attr_reader :processing_status_attr

      def initialize(processing_status_attr)
        @processing_status_attr = processing_status_attr
      end

      def self.name(processing_status_attr)
        new(processing_status_attr).find_by_name
      end

      def self.id(processing_status_attr)
        new(processing_status_attr).find_by_id
      end

      def find_by_name
        STATUS.key(processing_status_attr).to_s
      end

      def find_by_id
        STATUS[processing_status_attr.to_sym]
      end
    end
  end
end
