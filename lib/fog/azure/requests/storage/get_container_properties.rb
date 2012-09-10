module Fog
  module Storage
    class Azure
      class Real
        # no parser is needed we read from headers
        #require 'fog/azure/parsers/storage/get_container_properties'
        
        def get_container_properties(name, options = {})
          # This operation will only nead to change the query string
          # So the options hash is passed to the query and not headers
          request(
          expects: 200,
          headers: {},
          path: name,
          method: :get,
          query: {
            'restype' => 'container'
            }.merge!(options || {})
          )
        end
      end
      class Mock
        def get_container_properties(options = {})
        end
      end
    end
  end
end