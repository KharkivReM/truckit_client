require 'active_support/dependencies/autoload'
require 'rest_client'
require 'jbuilder'
require 'truckit_client/base_client'

module TruckitClient
  extend ActiveSupport::Autoload
  autoload :BaseClient
  autoload :User
end
