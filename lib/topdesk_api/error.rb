# tested via spec/middleware/response/raise_error_spec.rb
module TopdeskAPI
  module Error
    class ClientError < Faraday::ClientError
      attr_reader :wrapped_exception

      def to_s
        if response
          "#{super} -- #{response[:method]} #{response[:url]}"
        else
          super
        end
      end
    end

    class RecordInvalid < ClientError
      attr_accessor :errors

      def initialize(*)
        super

        body = response[:body]
        body = body.is_a?(Array) ? body.first : body
        @errors = body['message'] if body.is_a?(Hash)
        @errors ||= {}
      end

      def to_s
        "Error: #{@errors}"
      end
    end

    class NetworkError < ClientError; end
    class RecordNotFound < ClientError; end
    class RateLimited < ClientError; end
    class ParamsRequired < ClientError; end
  end
end
