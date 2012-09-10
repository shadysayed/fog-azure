require 'fog/core/collection'
require 'fog/azure/models/storage/directory'

module Fog
  module Storage
    class Azure
      class Directories < Fog::Collection
        include Fog::Storage::Azure::Utils
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
          remap_attributes(options,{
            delimiter: 'delimiter',
            marker: 'marker',
            prefix: 'prefix'
          })
          response = connection.list_blobs(key, options)
          data = response.body
          directory = new(key: key)
          # copy what we know about into the files collection
          options = extract_sub_dictionary(data,
            'BlobPrefixes',
            'Marker',
            'Delimiter',
            'NextMarker',
            'Prefix'
          )
          directory.files.merge_attributes(options)
          directory.files.load(data['Content'])
          directory
        rescue Excon::Errors::NotFound
          nil
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