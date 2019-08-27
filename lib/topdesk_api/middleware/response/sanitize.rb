module TopdeskAPI
  module Middleware
    module Response
      class Sanitize < Faraday::Response::Middleware
        def on_complete(env)
          env[:body].scrub!('') if env[:body]
        end
      end
    end
  end
end
