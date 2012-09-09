require 'fog/core/collection'
require 'fog/azure/models/storage/directory'

module Fog
  module Storage
    class Azure
      class Directories < Fog::Collection
        model Fog::Storage::Azure::Directory
        attribute :next_marker, :aliases => ['NextMarker']
        attribute :marker, :aliases => ["Marker"]
        attribute :prefix, :aliases => ['Prefix']
        attribute :max_results, :aliases => ['MaxResuls']
        def all(options = {})
          response = connection.list_containers(options)
          merge_attributes(response.body)
          data = response.body['Containers']
          load(data)
        end
        
        def get(key, options = {})
        end
        
        alias :each_dir_this_page :each
        def each
          if block_given?
            subset = dup.all
            
            subset.each_dir_this_page { |d| yield d }
            while subset.next_marker != nil
              subset = subset.all(:marker => subset.next_marker)
              subset.each_dir_this_page { |d| yield d }
            end
          end
          self
        end
      end
    end
  end
end