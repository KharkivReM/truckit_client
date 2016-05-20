module TruckitClient
  class ServiceApplication < BaseClient

    def create(user_id, options = {})
      modify_data("POST", "/users/#{user_id}/service_applications") do |json|
        json.service_application do
          json.service_type       options[:service_type]
          json.truck_type         options[:truck_type]
          json.from_address do
            json.line1        options[:from_address][:line1]
            json.city         options[:from_address][:city]
            json.state        options[:from_address][:state]
            json.postal_code  options[:from_address][:postal_code]
          end
          json.to_address do
            json.line1        options[:to_address][:line1]
            json.city         options[:to_address][:city]
            json.state        options[:to_address][:state]
            json.postal_code  options[:to_address][:postal_code]
          end
        end
      end
    end
  end
end
