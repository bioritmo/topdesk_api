require "bundler/setup"
require "topdesk_api"
require 'webmock/rspec'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def dump_json(body = {})
    JSON.dump(body)
  end

  def stub_json(verb, path_matcher, body = dump_json, options = {})
    stub_request(verb, path_matcher).to_return(
      {
        body: body,
        headers: { content_type: "application/json",
                   content_length: body.size }
      }.merge(options)
    )
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
