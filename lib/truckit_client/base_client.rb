#require 'pry'

module TruckitClient
  class BaseClient
    attr_reader :host, :version, :uid, :client, :access_token 

    # @param [String] host Truckit hostname
    # @param [String] version Version of Truckit API
    # @param [Hash] options Client details
    # @option options [String] :uid: A unique value that is used to identify the user. (phone number / email / driver license)
    # @option options [String] :client: This enables the use of multiple simultaneous sessions on different clients
    # @option options [String] :access_token: hashed version of password
    def initialize(host, version, options = {})
      @host          = host
      @version       = version
      @uid           = options.fetch(:uid, nil)
      @client        = options.fetch(:client, nil)
      @access_token  = options.fetch(:access_token, nil)
    end

    # GET json encoded message.
    # 
    # @param [String] path API URI
    # @param [Proc] block block to build json params
    # @return [Hash or String]
    def get_data(path, &block)
      url = "#{host}/api/v#{version}/#{path}"
      params = Jbuilder.encode(&block) if block_given?
      params ||= {}
      resource = RestClient::Resource.new(
        url, 
        headers: {
          "uid"           => @uid,
          "client"        => @client,
          "access-token"  => @access_token
        },
        :verify_ssl => false
      )
      resource.get(params) do |response, request, result, &blk|
        case response.code
        when 200
          auth_data = {
            uid:          response.headers[:uid],
            client:       response.headers[:client],
            access_token: response.headers[:access_token]
          }
          JSON.parse(response).merge(auth_data)
        when 404
          nil
        else
          JSON.parse(response)
        end
      end
    end
    private :get_data

    # POST/PUT json encoded message.
    # 
    # @param [String] method HTTP method (POST for create, PUT for update) 
    # @param [String] path API URI
    # @param [Proc] block block to build json params
    # @return [Hash or String]
    def modify_data(method, path, &block)
      url = "#{host}/api/v#{version}/#{path}"
      params = Jbuilder.encode(&block)
      resource = RestClient::Resource.new(
        url, 
        headers: {
          "uid"           => @uid,
          "client"        => @client,
          "access-token"  => @access_token
        }
      )
      resource.send(method.downcase, params, content_type: :json, accept: :json) do |response, request, result, &blk|
        case response.code
        when 200
          if response.blank?
            true
          else
            auth_data = {
              uid:          response.headers[:uid],
              client:       response.headers[:client],
              access_token: response.headers[:access_token]
            }
            JSON.parse(response).merge(auth_data)
          end
        else
          if response.blank?
            false
          else
            JSON.parse(response) rescue { error: response }
          end
        end
      end
    end
    private :modify_data

    # DELETE json encoded message.
    # 
    # @param [String] path API URI
    # @param [Proc] block block to build json params
    # @return [Hash or String]
    def delete_data(path, &block)
      url = "#{host}/api/v#{version}/#{path}"
      params = Jbuilder.encode(&block) if block_given?
      params ||= {}
      resource = RestClient::Resource.new(
        url, 
        headers: {
          "uid"           => @uid,
          "client"        => @client,
          "access-token"  => @access_token
        }
      )
      resource.delete(params) do |response, request, result, &blk|
        case response.code
        when 200
          if response.blank?
            true
          else
            auth_data = {
              uid:          response.headers[:uid],
              client:       response.headers[:client],
              access_token: response.headers[:access_token]
            }
            JSON.parse(response).merge(auth_data)
          end
        when 404
          nil
        else
          JSON.parse(response)
        end
      end
    end
    private :delete_data
  end
end
