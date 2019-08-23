RSpec.describe TopdeskAPI::Resources::Country do
  include_context 'client_service'

  let(:url_server) { "https://example/tas/api/countries" }
  let(:name) { 'Argentina' }
  let(:id) { '6b1efe99-69e0-4e84-820f-caaf11cfd749' }
  let(:country) { described_class.new(client) }

  context '#find_by_name' do
    let(:params_url) { "?name=#{name}&page_size=100" }
    let(:return_body) do
      [{"id": "#{id}", "name": "#{name}"}].to_json
    end
    let(:mount_url) { url_server + params_url }
    let(:request_get) do
      stub_request(:get, mount_url).
        to_return(headers: { content_type: 'application/json' },
                  status: status,
                  body: return_body)
    end

    before { request_get }
    subject { country.find_by_name(name) }

    context 'when find a country by name' do
      let(:status) { 200 }

      it 'return the country' do
        expect(subject.id).to eq(id)
      end
    end

    context 'when do not find a country by name' do
      let(:status) { 204 }
      let(:name) { 'not_found_country' }

      it { is_expected.to be_nil }
    end
  end
end
