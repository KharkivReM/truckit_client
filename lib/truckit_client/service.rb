module TruckitClient
  class Service < BaseClient

    def create(user_id, service_application_id)
      modify_data("POST", "/users/#{user_id}/service_applications/#{service_application_id}/services") do
      end
    end

    def start(service_id)
      modify_data("POST", "/services/#{service_id}/start") do
      end
    end

    def complete(service_id)
      modify_data("POST", "/services/#{service_id}/complete") do
      end
    end

    def cancel(service_id)
      modify_data("POST", "/services/#{service_id}/cancel") do
      end
    end
  end
end
