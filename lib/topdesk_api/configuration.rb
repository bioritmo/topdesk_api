module TopdeskAPI
  # Holds the configuration options for the client and connection
  class Configuration
    # @return [String] The basic auth username.
    attr_accessor :username

    # @return [String] The basic auth password.
    attr_accessor :password

    # @return [String] The basic auth token.
    attr_accessor :token

    # @return [String] The API url. Must be https unless {#allow_http} is set.
    attr_accessor :url

    # @return [Hash] Client configurations (eg ssh config) to pass to Faraday
    attr_accessor :client_options

    # @return [Symbol] Faraday adapter
    attr_accessor :adapter

    def initialize
      @client_options = {}
    end

    def options
      {
        :headers => {
          :accept => 'application/json',
          :user_agent => 'TopdeskAPI Ruby'
        },
        :request => {
          :open_timeout => 10
        },
        :url => @url
      }.merge(client_options)
    end
  end
end
