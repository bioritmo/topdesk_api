RSpec.describe TopdeskAPI::Resources::Department do
  include_context 'client_service'

  let(:url_server) { "https://example/tas/api/departments" }
  let(:name) { 'Assistente' }
  let(:id) { '9f3f29fc-de78-471f-8c99-0bfcb851362c' }
  let(:department) { described_class.new(client) }

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
    subject { department.find_by_name(name) }

    context 'when find a department by name' do
      let(:status) { 200 }

      it 'return the department id ' do
        expect(subject.id).to eq(id)
      end
    end

    context 'when do not find a department by name' do
      let(:status) { 204 }
      let(:name) { 'not_found_department' }
      it { is_expected.to be_nil }
    end
  end
end
