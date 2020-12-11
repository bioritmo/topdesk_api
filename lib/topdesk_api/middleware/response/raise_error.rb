require 'topdesk_api/error'

module TopdeskAPI
  module Middleware
    module Response
      class RaiseError < Faraday::Response::RaiseError
        def call(env)
          super
        rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
          raise Error::NetworkError.new(e, env)
        end

        def on_complete(env)
          case env[:status]
          when 404, 204
            raise Error::RecordNotFound, env
          when 422, 403, 400, 413
            raise Error::RecordInvalid, env
          when 100..199, 401..599, 300..303, 305..399
            raise Error::NetworkError, env
          end
        end
      end
    end
  end
end
