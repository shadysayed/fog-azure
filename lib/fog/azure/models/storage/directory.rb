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
        
        def files
          @files ||= Fog::Storage::Azure::Files.new(directory: self, connection: connection)
        end
      end
    end
  end
end