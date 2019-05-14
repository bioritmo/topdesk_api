require 'spec_helper'

class SimpleClient < TopdeskAPI::Client
  def build_connection
    "FOO"
  end
end

RSpec.describe TopdeskAPI::Client do
  context "#initialize" do
    it "should require a block" do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it "should handle valid url" do
      expect do
        described_class.new do |config|
          config.url = "https://example.topdesk.com/api/v1"
        end.to_not raise_error
      end
    end
  end

  context "#connection" do
    subject do
      described_class.new do |config|
        config.url = "https://example.topdesk.com/api/v1"
      end
    end

    it "should initially be false" do
      expect(subject.instance_variable_get(:@connection)).to be_falsey
    end

    it "connection should be initialized on first call to #connection" do
      expect(subject.connection).to be_instance_of(Faraday::Connection)
    end
  end
end
