require 'spec_helper'

class SimpleClient < TopdeskAPI::Client
  def build_connection
    'FOO'
  end
end

RSpec.describe TopdeskAPI::Client do
  let(:client) do
    described_class.new do |config|
      config.url = 'https://example.topdesk.com/api/v1'
    end
  end

  context 'when initialize' do
    it 'require a block' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'handle valid url' do
      expect { client }.not_to raise_error
    end
  end

  context 'when connection' do
    it 'initially be false' do
      expect(client.instance_variable_get(:@connection)).to be_falsey
    end

    it 'be initialized on first call to #connection' do
      expect(client.connection.instance_of?(Faraday::Connection)).to be(true)
    end
  end

  context 'when call ticket' do
    it 'initially ticket class' do
      expect(
        client.ticket.instance_of?(TopdeskAPI::Resources::Ticket)
      ).to be(true)
    end
  end

  context 'when call operator' do
    it 'initially operator class' do
      expect(
        client.operator.instance_of?(TopdeskAPI::Resources::Operator)
      ).to be(true)
    end
  end

  context 'when call person' do
    it 'initially operator class' do
      expect(
        client.person.instance_of?(TopdeskAPI::Resources::Person)
      ).to be(true)
    end
  end

  context 'when call department' do
    it 'initially department class' do
      expect(
        client.department.instance_of?(TopdeskAPI::Resources::Department)
      ).to be(true)
    end
  end

  context 'when call branch' do
    it 'initially branch class' do
      expect(
        client.branch.instance_of?(TopdeskAPI::Resources::Branch)
      ).to be(true)
    end
  end

  context 'when call person_extra_field_a' do
    it 'initially person_extra_field_a class' do
      expect(
        client.person_extra_field_a.instance_of?(TopdeskAPI::Resources::PersonExtraFieldA)
      ).to be(true)
    end
  end
end
