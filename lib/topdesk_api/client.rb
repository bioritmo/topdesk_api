require 'faraday'
require 'json'

require 'topdesk_api/version'
require 'topdesk_api/configuration'

module TopdeskAPI
  class Client
    attr_reader :config, :callbacks

    def initialize
      raise ArgumentError, 'block not given' unless block_given?

      @config = TopdeskAPI::Configuration.new
      yield config
      @callbacks = []
    end

    def connection
      @connection ||= build_connection
    end

    def ticket(params = {})
      TopdeskAPI::Resources::Ticket.new(self, params)
    end

    def department
      TopdeskAPI::Resources::Department.new(self)
    end

    def budget_holder
      TopdeskAPI::Resources::BudgetHolder.new(self)
    end

    def country
      TopdeskAPI::Resources::Country.new(self)
    end

    def branch
      TopdeskAPI::Resources::Branch.new(self)
    end

    def operator(params ={})
      TopdeskAPI::Resources::Operator.new(self, params)
    end

    def person(params ={})
      TopdeskAPI::Resources::Person.new(self, params)
    end

    def insert_callback(&block)
      @callbacks << block
    end

    private

    def build_connection
      Faraday.new(config.options) do |builder|
        adapter = config.adapter || Faraday.default_adapter

        # response
        builder.use TopdeskAPI::Middleware::Response::RaiseError
        builder.use TopdeskAPI::Middleware::Response::ParseJson
        builder.use TopdeskAPI::Middleware::Response::Sanitize

        # request
        builder.use Faraday::Request::BasicAuthentication, config.username, config.password
        builder.request :multipart
        builder.adapter(*adapter)
      end
    end
  end
end
