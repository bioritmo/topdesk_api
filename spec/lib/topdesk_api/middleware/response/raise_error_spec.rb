
RSpec.describe TopdeskAPI::Middleware::Response::RaiseError do
  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = 'https://example.topdesk.com/'
    end
  end

  context 'with a failed connection' do
    context 'connection failed' do
      before(:each) do
        stub_request(:any, /.*/).to_raise(Faraday::Error::ConnectionFailed)
      end

      it 'raise NetworkError' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::NetworkError)
        )
      end
    end

    context 'connection timeout' do
      before(:each) do
        stub_request(:any, /.*/).to_timeout
      end

      it 'raise NetworkError' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::NetworkError)
        )
      end
    end
  end

  context 'status errors' do
    let(:body) { "" }

    before(:each) do
      stub_request(:any, /.*/).to_return(:status => status, :body => body,
        :headers => { :content_type => "application/json" })
    end

    context 'with status = 404' do
      let(:status) { 404 }

      it 'raise RecordNotFound when status is 404' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::RecordNotFound)
        )
      end
    end

    context 'with status in 400...600' do
      let(:status) { 500 }

      it 'raise NetworkError' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::NetworkError)
        )
      end
    end

    context 'with status in 1XX' do
      let(:status) { 100 }

      it 'raise NetworkError' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::NetworkError)
        )
      end
    end

    context 'with status = 304' do
      let(:status) { 304 }

      it 'not raise' do
        client.connection.get '/abcdef'
      end
    end

    context 'with status in 3XX' do
      let(:status) { 302 }

      it 'raises NetworkError' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::NetworkError)
        )
      end
    end

    context 'with status = 422' do
      let(:status) { 422 }

      it 'raise RecordInvalid' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::RecordInvalid)
        )
      end

      context 'with a body' do
        let(:body) { JSON.dump(:details => 'hello') }

        it 'return RecordInvalid with proper message' do
          begin
            client.connection.get '/non_existent'
          rescue TopdeskAPI::Error::RecordInvalid => e
            expect(e.errors).to eq('hello')
            expect(e.to_s).to eq('TopdeskAPI::Error::RecordInvalid: hello')
          else
            fail
          end
        end
      end
    end

    context 'with status = 413' do
      let(:status) { 413 }

      it 'raise RecordInvalid' do
        expect { client.connection.get '/non_existent' }.to(
          raise_error(TopdeskAPI::Error::RecordInvalid)
        )
      end

      context 'with a body' do
        let(:body) { JSON.dump(:description => 'this file is big') }

        it 'return RecordInvalid with proper message' do
          begin
            client.connection.get '/non_existent'
          rescue TopdeskAPI::Error::RecordInvalid => e
            expect(e.errors).to eq('this file is big')
            expect(e.to_s).to eq('TopdeskAPI::Error::RecordInvalid: this file is big')
          else
            fail
          end
        end
      end
    end

    context 'with status = 200' do
      let(:status) { 200 }

      it 'does not raise' do
        client.connection.get '/abcdef'
      end
    end
  end
end
