require 'fog/core/model'

module Fog
  module Storage
    class Azure
      class Directory < Fog::Model
        # identity :key, :aliases => ['name']
        identity :name, :aliases => ['Name']
        attribute :metadata
      end
    end
  end
end