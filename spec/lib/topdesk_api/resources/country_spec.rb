RSpec.describe TopdeskAPI::Resources::Country do
  include_context 'when have client service'

  let(:url_server) { 'https://example/tas/api/countries' }
  let(:name) { 'Argentina' }
  let(:id) { '6b1efe99-69e0-4e84-820f-caaf11cfd749' }
  let(:country) { described_class.new(client) }

  context 'when try to find by name' do
    let(:country_find) { country.find_by_name(name) }

    let(:params_url) { "?name=#{name}&page_size=100" }
    let(:return_body) do
      [{ "id": id.to_s, "name": name.to_s }].to_json
    end
    let(:mount_url) { url_server + params_url }
    let(:request_get) do
      stub_request(:get, mount_url).
        to_return(headers: { content_type: 'application/json' },
                  status: status,
                  body: return_body)
    end

    before { request_get }

    context 'when find a country by name' do
      let(:status) { 200 }

      it 'return the country' do
        expect(country_find.id).to eq(id)
      end
    end

    context 'when do not find a country by name' do
      let(:status) { 204 }
      let(:name) { 'not_found_country' }

      it { expect(country_find).to be_nil }
    end
  end
end
