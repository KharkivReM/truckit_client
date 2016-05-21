module TruckitClient
  class User < BaseClient


    def signup(email: nil, password: nil, password_confirmation: nil,
      phone_number: nil, full_name: nil, agree_to_terms_flg: nil)
      modify_data("POST", '/users') do |json|
        json.email                  email
        json.password               password
        json.password_confirmation  password_confirmation
        json.phone_number           phone_number
        json.full_name              full_name
        json.agree_to_terms_flg     agree_to_terms_flg
      end
    end

    def login(email: nil, password: nil)
      modify_data("POST", '/users/sign_in') do |json|
        json.email                  email 
        json.password               password
      end
    end

    def show(user_id)
      get_data("/users/#{user_id}")
    end

    def update(user_id, email: nil, agree_to_terms_flg: nil, full_name: nil,
      phone_number: nil)
      modify_data("PUT", "/users/#{user_id}") do |json|
        json.user do
          json.email                  email
          json.agree_to_terms_flg     agree_to_terms_flg
          json.full_name              full_name
          json.phone_number           phone_number
        end
      end
    end
  end
end
