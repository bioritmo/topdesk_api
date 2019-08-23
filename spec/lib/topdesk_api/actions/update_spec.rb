require 'spec_helper'

RSpec.describe TopdeskAPI::Actions::Update do
  include_context 'params_topdesk'
  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = url_server
    end
  end

  let(:login) { 'OPERADOR' }
  let(:email) { 'operatortest1@test.com' }
  let(:id) { 'd2520ee7-7414-4c8c-9447-8582279d6cfb' }
  let(:url_server) { 'https://example.topdesk.com' }

  subject { described_class.call(client, id, params_topdesk, url) }

  describe '#update' do
    let(:request_put) do
      stub_request(:put, base_url).to_return(
        headers: { content_type: 'application/json' },
        body: body,
        status: status
      )
    end

    context 'operators' do
      let(:url) { 'operators' }
      let(:base_url) { "#{url_server}/tas/api/operators/id/#{id}" }
      let(:body) { { id: id }.to_json }

      context 'when update an operator' do
        context 'and response return 200' do
          let(:status) { 200 }

          it 'update operator' do
            request_put
            expect(subject).to be(true)
          end
        end

        context 'when response return 400' do
          let(:login) { ' ' }
          let(:status) { 400 }

          it 'does not update operator' do
            request_put
            expect { subject }.to raise_error(TopdeskAPI::Error::RecordInvalid)
          end
        end
      end
    end

    context 'when trying to update a new person' do
      let(:url) { 'persons' }
      let(:base_url) { "#{url_server}/tas/api/persons/id/#{id}" }
      let(:body) { { id: id }.to_json }

      context 'and response return 200' do
        let(:status) { 200 }

        it 'update person' do
          request_put
          expect(subject).to be(true)
        end
      end
    end
  end
end
