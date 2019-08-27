RSpec.describe TopdeskAPI::Resources::Branch do
  include_context 'when have client service'

  let(:url_server) { 'https://example/tas/api/branches' }
  let(:name) { 'ABR' }
  let(:id) { 'f3431ec7-68d8-4bb9-86d7-3a13fdaf779a' }
  let(:branch) { described_class.new(client) }

  context 'when try to find by name' do
    let(:branch_find) { branch.find_by_name(name) }

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

    context 'when find a branch by name' do
      let(:status) { 200 }

      it 'return the branch' do
        expect(branch_find.id).to eq(id)
      end
    end

    context 'when do not find a branch by name' do
      let(:status) { 204 }
      let(:name) { 'not_found_branch' }

      it { expect(branch_find).to be_nil }
    end
  end
end
