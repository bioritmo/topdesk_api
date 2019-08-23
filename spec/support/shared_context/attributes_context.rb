shared_context 'params_topdesk' do
  let(:params_topdesk) do
    {
      surName: last_name,
      firstName: first_name,
      password: login,
      email: email,
      department: {
        id: department_id
      },
      mobileNumber: cell_phone,
      branch: {
        id: location_id
      }
    }
  end
  let(:department_id) { 'f47d5111-5357-4a51-a252-22cc7213404c' }
  let(:last_name) { 'one' }
  let(:first_name) { 'person' }
  let(:login) { 'person_one_1' }
  let(:email) { 'person_one@test.com' }
  let(:cell_phone) { '37630505078' }
  let(:location_id) { '1e752061-ce35-4385-9865-7854090ea82d' }
end

shared_context 'client_service' do
  let(:client) do
    TopdeskAPI::Client.new do |config|
      config.url = url_server
    end
  end
end
