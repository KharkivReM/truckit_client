require 'spec_helper'

describe TruckitClient::ServiceApplication do |variable|
  let(:host) { "http://localhost:3000" }
  let(:version) { 1 }
  let(:email) { Faker::Internet.email  }
  let(:password) { 'secret123' }

  let(:signup_client) { TruckitClient::User.new(host, version) } 
  let(:signup_response) {
    signup_client.signup(
      email,
      {
        password:               password,
        password_confirmation:  password
      }
    )
  }
  let(:user_id) { signup_response['data']['id'] }
  let(:application_client) {
    TruckitClient::ServiceApplication.new(host, version, {
      uid:            signup_response[:uid],
      client:         signup_response[:client],
      access_token:   signup_response[:access_token]
    })
  }

  let(:options) {
    {
      service_type:   'regular',
      truck_type:     'mini',
      from_address: {
        line1:        '200 W.Jackson Blvd',
        city:         'Chicago',
        state:        'IL',
        postal_code:  '60606'
      },
      to_address: {
        line1:        '3900 N.Pine Grove',
        city:         'Chicago',
        state:        'IL',
        postal_code:  '60613'
      }
    }
  }

  describe 'create service application' do
    it 'successfully create application service' do
      response = application_client.create(
        user_id,
        options
      )
      expect(response['service_application']).to be_present
      application = response['service_application']
      expect(application['id']).to be_present
      expect(application['service_type']).to eq('regular')
      expect(application['truck_type']).to eq('mini')
      expect(application['distance']).to eq('7.0')
    end

    it 'returns back validation error' do
      response = application_client.create(
        user_id,
        options.merge(service_type: nil)
      )

      expect(response['errors'].first['error']).to eq('exception')
      expect(response['errors'].first['message']).to match(/Invalid parameter 'service_type'/)
      expect(response['service_application']).not_to be_present
    end
  end
end
