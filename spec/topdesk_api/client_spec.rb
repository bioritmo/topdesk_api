require 'spec_helper'

class SimpleClient < TopdeskAPI::Client
  def build_connection
    'FOO'
  end
end

RSpec.describe TopdeskAPI::Client do
  context 'when initialize' do
    let(:client) do
      described_class.new do |config|
        config.url = 'https://example.topdesk.com/api/v1'
      end
    end

    it 'require a block' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'handle valid url' do
      expect(client).not_to raise_error
    end
  end

  context 'when connection' do
    let(:client) do
      described_class.new do |config|
        config.url = 'https://example.topdesk.com/api/v1'
      end
    end

    it 'initially be false' do
      expect(client.instance_variable_get(:@connection)).to be_falsey
    end

    it 'be initialized on first call to #connection' do
      expect(client.connection).to instance_of?(Faraday::Connection)
    end
  end
end