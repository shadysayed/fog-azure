require 'fog-azure'
require 'fog/storage'
require 'waz-blobs'

module Fog
  module Storage
    class Azure < Fog::Service
      
      requires :azure_storage_account_name, :azure_storage_secret_key
      recognizes :https?
      
      secrets :azure_storage_secret_key
      
      model_path 'fog/azure/models/storage'
      collection  :directories
      model       :directory
      collection  :files
      model       :file
      
      request_path 'fog/azure/requests/storage'
      # The following are the requests that azure supports. Uncomment the one you want to implement.
      request :list_containers
      # request :set_blob_service_properties
      # request :get_blob_service_properties
      request :create_container
      request :get_container_properties
      # request :get_container_metadata
      # request :set_container_metadata
      request :get_container_acl
      request :set_container_acl
      # request :lease_container
      request :delete_container
      request :list_blobs
      # request :put_blob
      request :get_blob
      request :get_blob_properties
      # request :set_blob_properties
      # request :get_blob_metadata
      # request :set_blob_metadata
      # request :delete_blob
      # request :lease_blob
      # request :snapshot_blob
      # request :copy_blob
      # request :abort_copy_blob
      # request :put_block
      # request :put_block_list
      # request :get_block_list
      # request :put_page
      # request :get_page_ranges
      
      
      module Utils
        # put common functions between real and mock here
        
        
        def extract_sub_dictionary(dict, *keys)
          result = {}
          for k, v in dict
            if keys.include? k
              result[k] = v
            end
          end
          result
        end
        
        def stringify_keys(dict)
          dict.inject({}) do |result, (key, value)|
            result[key.to_s] = value
            result
          end
        end
        
        def extract_ms_metadata(dict)
          result = {}
          r = /^x-ms-meta-(?<name>.+)/
          dict.keys.each do |key|
            if key && (match = r.match(key))
              result[match[:name]] = dict[key]
            end
          end
          result
        end
        
        def http_url(params, expires)
          scheme_host_path_query(params.merge(:scheme => 'http', :port => 80), expires)
        end

        def https_url(params, expires)
          scheme_host_path_query(params.merge(:scheme => 'https', :port => 443), expires)
        end

        
        private
        def scheme_host_path_query(params, expires)
          params[:scheme] ||= @scheme
          if params[:port] == 80 && params[:scheme] == 'http'
            params.delete(:port)
          end
          if params[:port] == 443 && params[:scheme] == 'https'
            params.delete(:port)
          end
          params[:headers] ||= {}
          #TODO: add signing for shared access signatures
          #call AWS escape, don't reinvent the wheel
          params[:path] = Fog::AWS.escape(params[:path]).gsub('%2F', '/')
          query = []
          if params[:query]
            for key, value in params[:query]
              #call the AWS escape, there is no need to reimplement
              query << "#{key}=#{Fog::AWS.escape(value)}"
            end
          end
          port_part = params[:port] && ":#{params[:port]}"
          "#{params[:scheme]}://#{params[:host]}#{port_part}/#{params[:path]}?#{query.join('&')}"
        end
        
      end
      
      class Real
        include Utils
        
        attr_reader :host
        attr_reader :scheme
        attr_reader :path
        
        # Initialize connection to azure blob store
        #
        # ==== Notes
        # options parameter must include values for :azure_storage_account_name and
        # :azure_storage_secret_key in order to create a connection
        #
        # ==== Examples
        #   s3 = Fog::Storage.new(
        #     :provider => "Azure",
        #     :azure_storage_account_name => your_azure_account_name,
        #     :azure_storage_secret_key => your_azure_storage_secret_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * Storage object with connection to Azure blob store.
        def initialize(options={})
          require 'fog/core/parser'
          require 'mime/types'
          
          setup_credentials(options)
          @path   = options[:path] || "/"
          @port   = options[:port] || 443
          @scheme = options[:scheme] || "https"
          @host = "#{@azure_storage_account_name}.blob.core.windows.net"

          #@connection = Fog::Connection.new "#{@scheme}://#{@host}:#{@port}"
          @connection = Fog::Connection.new "https://#{@host}"
        end
        
        
        def establish_connection(options = {}, &block)
          WAZ::Storage::Base.establish_connection(
          {:account_name => @azure_storage_account_name,
          :access_key => @azure_storage_secret_key}.merge(options),
          &block
          )
        end
        
        private
        
        def setup_credentials(options)
          @azure_storage_account_name = options[:azure_storage_account_name]
          @azure_storage_secret_key   = options[:azure_storage_secret_key]
          @hmac = Fog::HMAC.new('sha256', Base64.decode64(@azure_storage_secret_key))
        end
        
        def request(params, &block)
          # TODO: Add retry logic.
          #Setup headers
          # params[:method] :get, :post, ...etc
          # params[:query] = {:foo => 'bar'}
          # params[:path]
          # params[:headers]
          params[:headers] ||= {}
          params[:path] ||= '/'
          headers = params[:headers]
          
          if params[:method] && ![:get, 'GET'].include?(params[:method])
            content_length = 0
            if params[:body]
              content_length = params[:body].size
            end
            headers["Content-Length"] = content_length
          end
          headers["x-ms-Date"] = Time.new.httpdate
          headers["x-ms-version"] = "2009-09-19"
          headers["Authorization"] = "SharedKey #{@azure_storage_account_name}:#{get_signature(params)}"
          # raise headers.inspect
          begin
            response = @connection.request(params, &block)
          # rescue Excon::Errors::SocketError => e
          #   raise e.backtrace.inspect
          rescue Excon::Errors::TemporaryRedirect => e
            
          end
          response
        end
        
        def get_signature(params)
          signature = [
            params[:method].to_s.upcase,
            (params[:headers]["Content-Encoding"] or ""),
            (params[:headers]["Content-Language"] or ""),
            (params[:headers]["Content-Length"] or ""),
            (params[:headers]["Content-MD5"] or ""),
            (params[:headers]["Content-Type"] or ""),
            (params[:headers]["Date"] or ""),
            (params[:headers]["If-Modified-Since"] or ""),
            (params[:headers]["If-Match"] or ""),
            (params[:headers]["If-Non-Match"] or ""),
            (params[:headers]["If-Unmodified-Since"] or ""),
            (params[:headers]["Range"] or ""),
            canonicalize_headers(params[:headers]),
            canonicalize_resource(params)
          ].join("\n")
          # raise signature.inspect
          signed_string = @hmac.sign(signature)
          Base64.encode64(signed_string).chomp!
        end
        
        def canonicalize_headers(headers)
          headers.keys.select {|h| h.to_s.start_with? 'x-ms'}.map{ |h| "#{h.downcase.strip}:#{headers[h].strip}" }.sort{ |a, b| a <=> b }.join("\n")
        end
        def canonicalize_resource(params)
          result = ["/#{@azure_storage_account_name}/#{params[:path].sub('/', '')}",
            params[:query].keys.sort{ |a, b| a <=> b }.map {|k| "#{k.to_s.downcase.strip}:#{canonicalize_query_value(params[:query][k])}"}.join("\n")
            ].join("\n").chomp
          result
        end
        def canonicalize_query_value(value)
          if value.is_a? Array
            value.sort{|a,b| a<=>b}.join ","
          else
            value
          end
        end
      end
      
      class Mock
        include Utils
        def request(*args)
          Fog::Mock.not_implemented
        end
      end
    end
  end  
end