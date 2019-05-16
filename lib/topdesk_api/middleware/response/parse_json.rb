module TopdeskAPI
  module Middleware
    module Response
      class ParseJson < Faraday::Response::Middleware
        CONTENT_TYPE = 'Content-Type'.freeze
        dependency 'json'

        def on_complete(env)
          type = env[:response_headers][CONTENT_TYPE].to_s
          type = type.split(';', 2).first if type.index(';')

          return unless type == 'application/json'

          env[:body] = JSON.parse(env[:body]) unless env[:body].strip.empty?
        end
      end
    end
  end
end
