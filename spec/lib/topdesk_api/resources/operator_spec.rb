RSpec.describe TopdeskAPI::Resources::Operator do
  include_context 'params_topdesk'
  include_context 'client_service'

  let(:url_server) { "https://example" }
  let(:login) { 'OPERADOR' }
  let(:email) { 'operatortest1@test.com' }
  let(:id) { 'd2520ee7-7414-4c8c-9447-8582279d6cfb' }

  let(:operator) { described_class.new(client, params_topdesk) }

  describe 'update operator' do
    subject { operator.update(id, params_topdesk) }

    let(:base_url) { "#{url_server}/tas/api/operators/id/#{id}/" }
    let(:request_put) do
      stub_request(:put, base_url).to_return(
        headers: { content_type: 'application/json' },
        status: status,
        body: body
      )
    end

    context 'raise errors' do
      context 'when id is empty' do
        let(:id) { '' }

        it 'ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when id is nil' do
        let(:id) { nil }

        it 'ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when params are wrong' do
      let(:message) do
        "surName - The value for the field can only be 50 characters long."
      end
      let(:body) { {message: message }.to_json }
      let(:status) { 400 }

      it 'return errors' do
        request_put
        expect(subject).to be(false)
        expect(operator.errors).to eq(message)
      end
    end

    context 'when params are ok' do
      let(:body) { { id: id }.to_json }
      let(:status) { 200 }

      it 'update operator' do
        request_put
        expect(subject).to be(true)
        expect(operator.errors).to be_nil
      end
    end
  end

  describe 'find operator' do
    subject { operator.find_by(login) }

    context 'when login exist' do
      before do
        allow(TopdeskAPI::Actions::FindBy).to(
          receive(:call).and_return(operator_object)
        )
      end
      let(:operator_object) { double(id: id) }

      it 'return operator' do
        expect(subject.id).to eq(id)
      end
    end

    context 'when login does not exist' do
      before do
        allow(TopdeskAPI::Actions::FindBy).to(
          receive(:call).and_raise(TopdeskAPI::Error::RecordNotFound, '')
        )
      end

      it { is_expected.to be_nil }
    end
  end
end
