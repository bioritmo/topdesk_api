require 'spec_helper'

RSpec.describe TopdeskAPI::Actions::Create do
  include_context 'when have params topdesk'

  let(:create) { described_class.call(client, params_topdesk, url) }

  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = url_server
    end
  end
  let(:url_server) { 'https://example' }

  describe 'when try to create' do
    context 'when is a persons' do
      let(:url) { 'persons' }
      let(:tas_login) { { tasLoginName: login } }
      let(:id) { '4762f0a5-3acd-47cd-9f90-993b30a934d5' }
      let(:base_url) { "#{url_server}/tas/api/#{url}" }

      let(:request_post) do
        stub_request(:post, base_url).to_return(
          headers: { content_type: 'application/json' },
          body: body,
          status: status
        )
      end

      context 'when try create' do
        context 'when service response return 200' do
          let(:status) { 200 }
          let(:body) { { id: id }.to_json }

          it 'return person' do
            request_post
            expect(create).to be(true)
          end
        end

        context 'when response return 400' do
          let(:status) { 400 }
          let(:body) do
            { message: 'Password must be at least 5 characters' }.to_json
          end

          it 'raise error' do
            request_post
            expect { create }.to raise_error(TopdeskAPI::Error::RecordInvalid)
          end
        end
      end
    end
  end
end
