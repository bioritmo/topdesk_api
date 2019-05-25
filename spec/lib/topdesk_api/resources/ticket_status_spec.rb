RSpec.describe TopdeskAPI::Resources::TicketStatus do
  describe 'status name' do
    let(:ticket_status) { described_class.name(processing_status_id) }

    context 'when id is NOVO' do
      let(:processing_status_id) { 'a3e2ad64-16e2-4fe3-9c66-9e50ad9c4d69' }

      it 'return NEW' do
        expect(ticket_status).to eq('NEW')
      end
    end

    context 'when id is Aberto' do
      let(:processing_status_id) { '2817418e-5afc-4a8e-b2e4-7e4ff104e095' }

      it 'return OPEN' do
        expect(ticket_status).to eq('OPEN')
      end
    end

    context 'when id is Pendente' do
      let(:processing_status_id) { 'dc36014f-d7c2-4f84-a23f-129ed93ee5d5' }

      it 'return PENDING' do
        expect(ticket_status).to eq('PENDING')
      end
    end

    context 'when id is Aguardando' do
      let(:processing_status_id) { '2bc54ec5-fc66-4475-be58-03dc663a3c70' }

      it 'return HOLDING' do
        expect(ticket_status).to eq('HOLDING')
      end
    end

    context 'when id is Resolvido' do
      let(:processing_status_id) { '2f8c81f5-7f6c-4fad-b309-08b235bde18d' }

      it 'return RESOLVED' do
        expect(ticket_status).to eq('RESOLVED')
      end
    end

    context 'when id is Fechado' do
      let(:processing_status_id) { '9260dea6-e65c-4455-9f00-197fdb3383ce' }

      it 'return CLOSED' do
        expect(ticket_status).to eq('CLOSED')
      end
    end

    context 'when id is invalid' do
      let(:processing_status_id) { 'invalid' }

      it 'return blank' do
        expect(ticket_status).to eq('')
      end
    end
  end

  describe 'return id' do
    let(:ticket_status) { described_class.id(processing_status_name) }

    context 'when name is NEW' do
      let(:processing_status_name) { 'NEW' }

      it 'return NEW' do
        expect(ticket_status).to eq('a3e2ad64-16e2-4fe3-9c66-9e50ad9c4d69')
      end
    end

    context 'when name is invalid' do
      let(:processing_status_name) { 'invalid' }

      it 'return nil' do
        expect(ticket_status).to be_nil
      end
    end
  end
end
