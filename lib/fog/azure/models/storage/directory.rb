require 'fog/core/model'

module Fog
  module Storage
    class Azure
      class Directory < Fog::Model
        identity :key, :aliases => ['Name']
        attribute :last_modified, :aliases => ['Last-Modified']
        attribute :url, :aliases => ['Url']
        attribute :etag, :aliases => ['Etag']
        attribute :metadata, :aliases => ['Metadata']
      end
    end
  end
end