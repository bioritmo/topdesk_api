RSpec.describe TopdeskAPI::Resources::BudgetHolder do
  include_context 'when have client service'

  let(:url_server) { 'https://example/tas/api/budgetholders' }
  let(:name) { 'SP1' }
  let(:id) { '6b1efe99-69e0-4e84-820f-caaf11cfd749' }
  let(:budget_holder) { described_class.new(client) }

  context 'when find by name' do
    let(:budget_holder_find) { budget_holder.find_by_name(name) }

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

    context 'when find a budget holder by name' do
      let(:status) { 200 }

      it 'return the budget holder' do
        expect(budget_holder_find.id).to eq(id)
      end
    end

    context 'when do not find a budget' do
      let(:status) { 204 }
      let(:name) { 'not_found_budget' }

      it { expect(budget_holder_find).to be_nil }
    end
  end
end
