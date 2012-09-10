module Fog
  module Storage
    class Azure
      class Real
        require 'fog/azure/parsers/storage/list_blobs'
        
        
        def list_blobs(container_name, options = {})
          unless container_name
            raise ArgumentError.new('container_name is required')
          end
          request(
            expects: 200,
            headers: {},
            idempotent: true,
            method: :get,
            path: container_name,
            parser: Fog::Parsers::Storage::Azure::ListBlobs.new,
            # parser: Fog::Parsers::Base.new,
            query: {
              'restype' => 'container',
              'comp' => 'list'
            }.merge!(options)
          )
        end
        
      end
      class Mock
      end
    end
  end
end