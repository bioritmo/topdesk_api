require 'spec_helper'

RSpec.describe TopdeskAPI::Configuration do
  let(:configuration) { described_class.new }

  it 'properly merge options' do
    url = 'test.host'
    configuration.url = url
    expect(configuration.options[:url]).to eq(url)
  end

  it 'set accept header properly' do
    expect(configuration.options[:headers][:accept]).to eq('application/json')
  end

  it 'set user agent header properly' do
    expect(configuration.options[:headers][:user_agent]).to match(/TopdeskAPI Ruby/)
  end

  it 'set a default open_timeout' do
    expect(configuration.options[:request][:open_timeout]).to eq(10)
  end

  it 'merge options with client_options' do
    configuration.client_options = { ssl: false }
    expect(configuration.options[:ssl]).to eq(false)
  end
end
