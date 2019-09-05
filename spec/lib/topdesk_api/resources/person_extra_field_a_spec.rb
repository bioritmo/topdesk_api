RSpec.describe TopdeskAPI::Resources::PersonExtraFieldA do
  include_context 'when have client service'

  let(:url_server) { 'https://example/tas/api/personExtraFieldAEntries' }
  let(:name) { 'Professor - Smartfit - SmartSystem' }
  let(:id) { '2e7bedae-24ab-4231-8b04-4694cf4beb15' }
  let(:person_extrafield_a) { described_class.new(client) }

  context 'when find by name' do
    let(:person_extrafield_a_find) { person_extrafield_a.find_by_name(name) }

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

    context 'when find a person extrafield a by name' do
      let(:status) { 200 }

      it 'return the person extrafield a' do
        expect(person_extrafield_a_find.id).to eq(id)
      end
    end

    context 'when do not find by name' do
      let(:status) { 204 }
      let(:name) { 'not_found_budget' }

      it { expect(person_extrafield_a_find).to be_nil }
    end
  end
end
