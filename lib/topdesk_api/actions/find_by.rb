module TopdeskAPI
  module Actions
    class FindBy
      include TopdeskAPI::Objectivize

      attr_reader :client, :attribute, :value, :url, :parameter
      attr_accessor :errors

      def self.call(client, attribute, value, url, parameter)
        new(client, attribute, value, url, parameter).find_by
      end

      def initialize(client, attribute, value, url, parameter)
        @client = client
        @url = url
        @attribute = attribute
        @value = value
        @parameter = parameter
      end

      def find_by
        url_mounted = Addressable::URI.encode("/tas/api/#{url}?#{parameter}=#{value}&page_size=100")

        response = client.connection.get(url_mounted) do |req|
          req.headers['Content-Type'] = 'application/json'
          yield req if block_given?
        end

        register = find_exactly(response.body)
        raise TopdeskAPI::Error::RecordNotFound, response.body if register.nil?

        objectivize(register)
      end

      private

      def find_exactly(registers)
        registers.detect do |register|
          upcase(register[attribute]) == upcase(value)
        end
      end

      def upcase(value)
        value.upcase if value
      end
    end
  end
end
