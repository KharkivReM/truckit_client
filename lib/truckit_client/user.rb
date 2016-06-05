module TruckitClient
  class User < BaseClient


    def signup(email, options = {})
      modify_data("POST", '/users') do |json|
        json.email                  email
        json.password               options[:password]
        json.password_confirmation  options[:password_confirmation]
        json.phone_number           options[:phone_number]
        json.full_name              options[:full_name]
        json.agree_to_terms_flg     options[:agree_to_terms_flg]
      end
    end

    def login(email, password)
      modify_data("POST", '/users/sign_in') do |json|
        json.email                  email 
        json.password               password
      end
    end

    def show(user_id)
      get_data("/users/#{user_id}")
    end

    def update(user_id, options = {})
      modify_data("PUT", "/users/#{user_id}") do |json|
        json.user do
          json.email                  options[:email]
          json.agree_to_terms_flg     options[:agree_to_terms_flg]
          json.full_name              options[:full_name]
          json.phone_number           options[:phone_number]
        end
      end
    end
  end
end
