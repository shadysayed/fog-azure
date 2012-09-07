module Fog
  module Storage
    class Azure
      class Real
        require 'fog/azure/parsers/storage/list_containers'
        
        def list_containers(options = {})
          # establish_connection do
          #   WAZ::Blobs::Container.list.map{ |container| { name: container.name }  }       
          # end
          request(
          expects: 200,
          headers: options,
          method: :get,
          parser: Fog::Parsers::Storage::Azure::ListContainers.new,
          query: {'comp' => 'list'}
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