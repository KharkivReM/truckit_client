module TruckitClient
  class Service < BaseClient

    def create(user_id, service_application_id)
      modify_data("POST", "/users/#{user_id}/service_applications/#{service_application_id}/services") do
      end
    end
  end
end
