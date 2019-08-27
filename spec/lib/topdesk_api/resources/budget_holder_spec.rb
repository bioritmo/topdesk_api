RSpec.describe TopdeskAPI::Resources::BudgetHolder do
  include_context 'client_service'

  let(:url_server) { "https://example/tas/api/budgetholders" }
  let(:name) { 'SP1' }
  let(:id) { '6b1efe99-69e0-4e84-820f-caaf11cfd749' }
  let(:budget_holder) { described_class.new(client) }

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
    subject { budget_holder.find_by_name(name) }

    context 'when find a budget holder by name' do
      let(:status) { 200 }

      it 'return the budget holder' do
        expect(subject.id).to eq(id)
      end
    end

    context 'when do not find a budget' do
      let(:status) { 204 }
      let(:name) { 'not_found_budget' }

      it { is_expected.to be_nil }
    end
  end
end
