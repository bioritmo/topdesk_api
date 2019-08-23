RSpec.describe TopdeskAPI::Resources::Person do
  include_context 'params_topdesk'
  include_context 'client_service'

  let(:url_server) { "https://example" }
  let(:login) { 'person_one_1' }
  let(:email) { 'person1@test.com' }
  let(:document) { '37630505078' }
  let(:id) { '4762f0a5-3acd-47cd-9f90-993b30a934d5' }
  let(:ssp_login_name) { login }
  let(:person) { described_class.new(client, ssp_login_name) }

  describe '#update' do

    subject { person.update(id, params_topdesk) }

    let(:base_url) { "#{url_server}/tas/api/persons/id/#{id}" }
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
        expect(person.errors).to eq(message)
      end
    end

    context 'when params are ok' do
      let(:body) { { id: id }.to_json }
      let(:status) { 200 }

      it 'update person' do
        request_put
        expect(subject).to be(true)
        expect(person.errors).to be_nil
      end
    end
  end

  describe 'find person' do
    subject { person.find_by(login) }

    context 'when login exist' do
      before do
        allow(TopdeskAPI::Actions::FindBy).to(
          receive(:call).and_return(person_object)
        )
      end
      let(:person_object) { double(id: id) }

      it 'return person' do
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

  context '#create' do
    subject { person.create(params_topdesk) }

    let(:base_url) { "#{url_server}/tas/api/persons" }
    let(:request_post) do
      stub_request(:post, base_url).to_return(
        headers: { content_type: 'application/json' },
        status: status,
        body: body
      )
    end

    context 'when response return 400' do
      let(:message) do
        "surName - The value for the field can only be 50 characters long."
      end
      let(:body) { { message: message }.to_json }
      let(:status) { 400 }

      it 'raise params required' do
        request_post
        expect(subject).to be_falsy
        expect(person.errors).to eq(message)
      end
    end

    context 'when params are ok' do
      let(:body) { { id: id }.to_json }
      let(:status) { 200 }

      it 'create person' do
        request_post
        expect(subject).to be_truthy
        expect(person.errors).to be_nil
      end
    end
  end
end
