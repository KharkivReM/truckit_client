require 'spec_helper'

describe TruckitClient::Service do |variable|
  let(:host) { "http://localhost:3000" }
  let(:version) { 1 }
  let(:email) { Faker::Internet.email  }
  let(:password) { 'secret123' }

  let(:signup_client) { TruckitClient::User.new(host, version) } 
  let(:signup_response) {
    signup_client.signup(
      email:                  email,
      password:               password,
      password_confirmation:  password
    )
  }
  let(:user_id) { signup_response['data']['id'] }
  let(:user_hash) {
    {
      uid:            signup_response[:uid],
      client:         signup_response[:client],
      access_token:   signup_response[:access_token]
    }
  }

  let(:service_type) { 'regular' }
  let(:truck_type) { 'mini' }
  let(:from_zip) { '60606'}
  let(:to_zip) { '60613'}

  let(:options) {
    {
      service_type:   service_type,
      truck_type:     truck_type,
      from_address: {
        line1:        '200 W.Jackson Blvd',
        city:         'Chicago',
        state:        'IL',
        postal_code:  from_zip
      },
      to_address: {
        line1:        '3900 N.Pine Grove',
        city:         'Chicago',
        state:        'IL',
        postal_code:  to_zip
      }
    }
  }
  let(:application_client) {
    TruckitClient::ServiceApplication.new(host, version, user_hash)
  }
  let(:application_response) {
    application_client.create(
      user_id,
      options
    )
  }
  let(:service_application_id) do
    application_response['service_application']['id']
  end
  let(:service_client) {
    TruckitClient::Service.new(host, version, user_hash)
  }

  describe 'create service' do
    it 'successfully creates service' do
      response = service_client.create(
        user_id,
        service_application_id
      )
      expect(response['service']).to be_present
      parsed_service = response['service']
      expect(parsed_service['id']).to be_present
      expect(parsed_service['service_type']).to eq(service_type)
      expect(parsed_service['truck_type']).to eq(truck_type)
      expect(parsed_service['from_address']['postal_code']).to eq(from_zip)
      expect(parsed_service['to_address']['postal_code']).to eq(to_zip)
      expect(parsed_service['service_application']['id']).to eq(service_application_id)
    end

    it 'returns back not find application error' do
      response = service_client.create(
        user_id,
        service_application_id.to_i + 1
      )
      expect(response).to eq(false)
    end
  end

  context 'service life cycle' do
    let(:service_response) do
      service_client.create(
        user_id,
        service_application_id
      )
    end
   
    let(:service_id) do
      service_response['service']['id']
    end

    let(:carrier_email) { 'admin@messenger911.com' }
    let(:carrier_password) { 'm911_password' }

    let(:login_client) { TruckitClient::User.new(host, version) } 
    let(:login_response) {
      login_client.login(
        email:                  carrier_email,
        password:               carrier_password,
      )
    }
    let(:carrier_hash) {
      {
        uid:            login_response[:uid],
        client:         login_response[:client],
        access_token:   login_response[:access_token]
      }
    }
    let(:carrier_service_client) {
      TruckitClient::Service.new(host, version, carrier_hash)
    }


    it 'goes through successfull cycle' do
      response = carrier_service_client.start(service_id)
      expect(response['service']['service_status']).to eq('in_progress')
      response = carrier_service_client.complete(service_id)
      expect(response['service']['service_status']).to eq('completed')
    end
    
    it 'makes cancellation' do
      response = carrier_service_client.cancel(service_id)
      expect(response['service']['service_status']).to eq('canceled')
    end
  end
end
