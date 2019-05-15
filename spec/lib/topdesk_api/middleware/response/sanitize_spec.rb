RSpec.describe TopdeskAPI::Middleware::Response::Sanitize do
  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = "https://example.topdesk.com/"
    end
  end

  def fake_response(data)
    stub_json(:get, %r{arg}, data)
    response = client.connection.get('arg')
    expect(response.status).to eq(200)
    response
  end

  describe 'with bad characters' do
    let(:big_string) do
      "{\"x\":\"2015-01-02T15:16:15Z\", \"y\":\"\u0311\u0316\u01333\u0270"+
      "\u022711yeap!"+[0xd83d,0xdc4d].pack('U*')+"\"}"
    end

    let(:response) { fake_response(big_string) }

    it 'removes bad characters' do
      expect(response.body.to_s.valid_encoding?).to be(true)
      expect(response.body['y'].to_s).to eq("\u0311\u0316\u01333\u0270\u022711yeap!")
    end
  end
end
