module Fog
  module Storage
    class Azure
      class Real
        require 'fog/azure/parsers/storage/list_containers'
        
        def list_containers(options = {})
          # This operation will only nead to change the query string
          # So the options hash is passed to the query and not headers
          request(
          expects: 200,
          headers: {},
          method: :get,
          parser: Fog::Parsers::Storage::Azure::ListContainers.new,
          query: {
            'comp' => 'list',
            'include' => 'metadata'
            }.merge!(options || {})
          )
        end
      end
      class Mock
        def list_containers(options = {})
        end
      end
    end
  end
end