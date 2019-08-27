RSpec.describe TopdeskAPI::Actions::FindBy do
  let(:find) { described_class.call(client, attribute, value, url, parameter) }

  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = base_url
    end
  end
  let(:attribute) { 'topdesk_login_name' }
  let(:parameter) { 'topdesk_login_name' }
  let(:value) { 'operador' }
  let(:url) { 'operators' }

  context 'when try to find' do
    let(:base_url) { 'https://example.topdesk.com/tas/api/operators' }
    let(:params_url) { "?#{attribute}=#{value}&page_size=100" }
    let(:mount_url) { base_url + params_url }
    let(:request_get) do
      stub_request(
        :get,
        mount_url
      ).to_return(headers: { content_type: 'application/json' }, status: status)
    end

    context 'when do not found' do
      let(:value) { 'not-found' }
      let(:status) { 204 }

      it 'raise an error RecordNotFound' do
        request_get
        expect { find }.to(
          raise_error(TopdeskAPI::Error::RecordNotFound)
        )
      end
    end

    context 'when find an object' do
      let(:return_body) do
        [
          { "id": 'd2520ee7-7414-4c8c-9447-8582279d6cfb',
            "topdesk_login_name": 'operador' }
        ].to_json
      end
      let(:request_get) do
        stub_request(
          :get,
          mount_url
        ).to_return(headers: { content_type: 'application/json' },
                    body: return_body)
      end

      it 'return operator id' do
        request_get
        expect(find.id).to eq('d2520ee7-7414-4c8c-9447-8582279d6cfb')
      end
    end
  end
end
