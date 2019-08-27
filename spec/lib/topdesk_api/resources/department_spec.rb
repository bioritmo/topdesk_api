RSpec.describe TopdeskAPI::Resources::Department do
  include_context 'when have client service'

  let(:url_server) { 'https://example/tas/api/departments' }
  let(:name) { 'Assistente' }
  let(:id) { '9f3f29fc-de78-471f-8c99-0bfcb851362c' }
  let(:department_client) { described_class.new(client) }

  context 'when find by name' do
    let(:department) { department_client.find_by_name(name) }

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

    context 'when find a department by name' do
      let(:status) { 200 }

      it 'return the department id ' do
        expect(department.id).to eq(id)
      end
    end

    context 'when do not find a department by name' do
      let(:status) { 204 }
      let(:name) { 'not_found_department' }

      it { expect(department).to be_nil }
    end
  end
end
