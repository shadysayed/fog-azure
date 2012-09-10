require 'fog/core/model'

module Fog
  module Storage
    class Azure
      class Directory < Fog::Model
        
        VALID_ALCS = ['container', 'blob', nil]
        
        identity :key, :aliases => ['Name']
        attribute :last_modified, :aliases => ['Last-Modified']
        attribute :url, :aliases => ['Url']
        attribute :etag, :aliases => ['Etag']
        attribute :metadata, :aliases => ['Metadata']
        
        attr_reader :acl
        
        
        def acl=(new_acl)
          unless VALID_ALCS.include? new_acl
            raise ArgumentError.new("acl must be one of [#{VALID_ALCS.join(', ')}]")
          else
            @acl = new_acl
          end
        end
        
        def destroy
          requires :key
          connection.delete_container(key)
          true
        rescue Excon::Errors::NotFound => e
          false
        end
        
        
        def files
          @files ||= Fog::Storage::Azure::Files.new(directory: self, connection: connection)
        end
        
        def public=(new_public)
          self.acl = new_public ? 'blob' : nil
          new_public
        end
        
        def public_url
          requires :key
          # raise connection.get_container_acl(key).headers.inspect
          if ['container', 'blob'].include? connection.get_container_acl(key).headers['x-ms-blob-public-access']
            ::File.join "#{connection.scheme}://#{connection.host}", key
          else
            nil
          end
        end
        
        def save
          requires :key
          
          options = {}
          options['x-ms-blob-public-access'] = acl if acl
          
          connection.create_container(key, options)
          
          true
        end
        
      end
    end
  end
end