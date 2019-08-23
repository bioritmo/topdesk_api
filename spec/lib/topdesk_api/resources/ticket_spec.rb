RSpec.describe TopdeskAPI::Resources::Ticket do
  include_context 'client_service'
  let(:url_server) { 'https://example.topdesk.com' }

  describe 'create' do
    let(:id) { '1' }
    let(:params) { { caller: { id: id } } }
    let(:ticket) { described_class.new(client, params) }
    let(:return_body) { { id: id }.to_json }
    let(:request_post) do
      stub_request(
        :post,
        "#{url_server}/tas/api/incidents/"
      ).to_return(headers: { content_type: 'application/json' },
                  body: return_body)
    end

    it 'make connection' do
      request_post
      ticket.create(params)
      expect(request_post).to have_been_requested
    end

    context 'when objectivize' do
      it 'return an id' do
        request_post
        ticket.create(params)
        expect(ticket.id).to eq(id)
      end
    end
  end

  describe 'update!' do
    let(:id) { '1' }
    let(:params) { { id: id } }
    let(:ticket) { described_class.new(client, params) }
    let(:request_get) do
      stub_request(
        :get,
        "#{url_server}/tas/api/incidents/id/#{id}"
      ).to_return(headers: { content_type: 'application/json' },
                  body: return_body)
    end
    let(:ticket_found) { ticket.find_by_id(id) }
    let(:request_put) do
      stub_request(:put, "https://example.topdesk.com/tas/api/incidents/id/#{id}")
    end

    context 'when find ticket' do
      let(:return_body) { { id: '1' }.to_json }

      before do
        request_get
        request_put
      end

      it 'make update' do
        ticket_found.update!
        expect(request_put).to have_been_requested
      end

      it 'set attributes' do
        ticket_found.action = '<p> Issue solved </p>'
        ticket_found.processing_status = 'OPEN'
        ticket_found.update!
        expect(ticket_found.action).to eq('<p> Issue solved </p>')
      end
    end
  end

  describe 'find' do
    let(:id) { '1' }
    let(:ticket) { described_class.new(client, id) }
    let(:request_get) do
      stub_request(
        :get,
        "#{url_server}/tas/api/incidents/id/#{id}"
      ).to_return(headers: { content_type: 'application/json' },
                  body: body)
    end

    context 'when find a ticket' do
      let(:body) do
        '{
            "id": "1",
            "processingStatus": {
              "id": "a3e2ad64-16e2-4fe3-9c66-9e50ad9c4d69"
            }
        }'
      end
      let(:ticket_found) { ticket.find_by_id(id) }

      before { request_get }

      it 'by id' do
        request_get
        ticket.find_by_id(id)
        expect(request_get).to have_been_requested
      end

      context 'when objectivize' do
        it 'return an id' do
          expect(ticket_found.id).to eq(id)
        end

        it 'return a normalized status' do
          expect(ticket_found.processing_status_name).to eq('NEW')
        end
      end
    end

    context 'when do not found a ticket' do
      let(:body) { '' }
      let(:ticket_not_found) { ticket.find_by_id(id) }

      before { request_get }

      it 'return nil' do
        expect(ticket_not_found).to be_nil
      end
    end
  end

  describe 'change value of variables instances' do
    let(:params) { { caller: { id: '1' } } }
    let(:ticket) { described_class.new(client, params) }

    it 'set processes status id by name' do
      ticket.processing_status = 'NEW'
      expect(ticket.processing_status).to eq('a3e2ad64-16e2-4fe3-9c66-9e50ad9c4d69')
    end
  end
end
