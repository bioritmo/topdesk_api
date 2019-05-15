RSpec.describe TopdeskAPI::Resources::Ticket do
  describe 'create' do
    let(:client) do
      TopdeskAPI::Client.new do |config|
        config.url = 'https://example.topdesk.com/'
      end
    end
    let(:params) { { :caller => { :id => '1' } } }
    let(:ticket) { described_class.new(client, params) }
    let(:request_post) do
      stub_request(:post, 'https://example.topdesk.com/tas/api/incidents/')
    end

    it 'make connection' do
      request_post
      ticket.create
      expect(request_post).to have_been_requested
    end
  end
end
