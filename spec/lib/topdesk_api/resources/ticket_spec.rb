RSpec.describe TopdeskAPI::Resources::Ticket do
  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = 'https://example.topdesk.com/'
    end
  end
  describe 'create' do
    let(:params) { { :caller => { :id => '1' } } }
    let(:ticket) { described_class.new(client, params) }
    let(:request_post) do
      stub_request(:post, 'https://example.topdesk.com/tas/api/incidents/')
    end

    it 'make connection' do
      request_post
      ticket.create(params)
      expect(request_post).to have_been_requested
    end
  end

  describe 'find' do
    let(:id) { '1' }
    let(:ticket) { described_class.new(client, id) }
    let(:request_get) do
      stub_request(:get, "https://example.topdesk.com/tas/api/incidents/id/#{id}")
    end

    it 'find by id' do
      request_get
      ticket.find_by_id(1)
      expect(request_get).to have_been_requested
    end
  end
end
