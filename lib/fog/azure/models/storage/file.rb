require 'fog/core/model'
# require 'fog/azure/models/storage/version'

module Fog
  module Storage
    class Azure
      class File < Fog::Model
        
        identity :key, :aliases => 'Name'
        
      end
    end
  end
end