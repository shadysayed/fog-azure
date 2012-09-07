require 'fog/core/collection'
require 'fog/azure/models/storage/directory'

module Fog
  module Storage
    class Azure
      class Directories < Fog::Collection
        model Fog::Storage::Azure::Directory
        def all
          data = connection.list_containers.body['Containers']
          load(data)
        end
        
        def get(key, options = {})
        end
      end
    end
  end
end