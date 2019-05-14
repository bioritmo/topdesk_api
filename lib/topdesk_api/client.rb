require 'faraday'

require 'topdesk_api/version'
require 'topdesk_api/configuration'

module TopdeskAPI
  class Client
    attr_reader :config

    def initialize
      raise ArgumentError, 'block not given' unless block_given?

      @config = TopdeskAPI::Configuration.new
      yield config
    end

    # Creates a connection if there is none, otherwise returns the existing connection.
    #
    # @return [Faraday::Connection] Faraday connection for the client
    def connection
      @connection ||= build_connection
    end

    private

    def build_connection
      Faraday.new(config.options) do |builder|
        adapter = config.adapter || Faraday.default_adapter

        # request
        builder.use Faraday::Request::BasicAuthentication, config.username, config.password
        builder.request :multipart
        builder.adapter(*adapter)
      end
    end
  end
end
