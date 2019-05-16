RSpec.describe TopdeskAPI::Middleware::Response::ParseJson do
  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = 'https://example.topdesk.com/'
    end
  end

  context 'with another content-type' do
    before do
      stub_request(:get, /blergh/).to_return(
        :headers => { :content_type => 'application/xml' },
        :body => '<nope></nope>'
      )
    end

    it 'does not return nil body' do
      expect(client.connection.get('blergh').body).to eql('<nope></nope>')
    end
  end

  context 'with content-type application/json' do
    before do
      stub_request(:get, /blergh/).to_return(
        :headers => { :content_type => 'application/json' },
        :body => body
      )
    end

    context 'with a nil body' do
      let(:body) { nil }

      it 'return empty body' do
        expect(client.connection.get('blergh').body).to eql('')
      end
    end

    context 'with a empty body' do
      let(:body) { '' }

      it 'return empty body' do
        expect(client.connection.get('blergh').body).to eql('')
      end
    end

    context 'when proper json' do
      let(:body) { '{ "TESTDATA": true }' }

      it 'parse returned body' do
        expect(client.connection.get('blergh').body['TESTDATA']).to be(true)
      end
    end
  end
end
