require 'spec_helper'

describe TruckitClient::User  do |variable|
  let(:host) { "http://localhost:3000" }
  let(:version) { 1 }
  let(:email) { Faker::Internet.email  }
  let(:phone_number) { Faker::PhoneNumber.phone_number.gsub(/[^0-9]/, '') }
  let(:password) { 'secret123' }

  context 'without authentication token' do
    subject { TruckitClient::User.new(host, version) } 

    describe 'registration' do
      it 'sucessfull register a new user' do
        response = subject.signup(
          email,
          {
            phone_number:           phone_number,
            password:               password,
            password_confirmation:  password
          }
        )

        expect(response["status"]).to eq("success")
        data = response["data"]
        expect(data["id"]).to be_present
        expect(data["email"]).to eq(email)
        expect(data["phone_number"]).to eq(phone_number)
        expect(data["provider"]).to eq("email")

        expect(response[:uid]).to eq(email)
        expect(response[:client]).to be_present
        expect(response[:access_token]).to be_present
      end
    end

    describe "login" do
      before do
        subject.signup(
          email,
          {
            password:               password,
            password_confirmation:  password
          }
        )
      end

      it 'successfully authenticates user with phone number' do
        response = subject.login(
          email,
          password
        )

        data = response["data"]
        expect(data["id"]).to be_present
        expect(data["email"]).to eq(email)
        expect(data["provider"]).to eq("email")
        expect(response[:uid]).to eq(email)
        expect(response[:client]).to be_present
        expect(response[:access_token]).to be_present
      end

      it 'returns invalid authentication' do
        response = subject.login(
          email,
          'FAKE'
        )

        expect(response["errors"]).to be_present
        expect(response["errors"]).to include("Invalid login credentials. Please try again.")
      end
    end
  end

  context 'with authentication token' do
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
    let(:user_client) {
      TruckitClient::User.new(host, version, {
        uid:            signup_response[:uid],
        client:         signup_response[:client],
        access_token:   signup_response[:access_token]
      })
    }

    describe "user details" do
      it 'returns customer data' do
        response = user_client.show(user_id)
        data = response["user"]
        expect(data["id"]).to eq(user_id)
        expect(data["email"]).to eq(email)
      end

      it 'doesnt return data for invalid ID' do
        response = user_client.show(99999)
        expect(response).to be_nil
      end
    end

    describe 'update user info' do
      it 'successfully updates customer data' do
        new_email = Faker::Internet.email
        response = user_client.update(
          user_id,
          {
            agree_to_terms_flg:   true,
            email:                new_email
          }
        )

        data = response["user"]
        expect(data["id"]).to eq(user_id)
        expect(data['email']).to eq(new_email)
        expect(data["agree_to_terms_flg"]).to eq(true)
      end

      it 'doesnt update customer due to invalid email' do
        response = user_client.update(
          user_id,
          {
            email: "FAKE"
          }
        )

        expect(response["errors"]).to be_present
        expect(response['errors'][0]['error']).to eq('validation_failed')
        expect(response["errors"][0]["message"]).to include("is invalid")
        expect(response["errors"][0]["parameter"]).to eq("email")
      end
    end
  end
end
