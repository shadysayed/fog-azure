require 'fog/core/collection'
require 'fog/azure/models/storage/file'

module Fog
  module Storage
    class Azure
      class Files < Fog::Collection
        include Fog::Storage::Azure::Utils

        attribute :blob_prefixes, :aliases=> ['BlobPrefixes']
        attribute :delimiter, :aliases => 'Delimiter'
        attribute :directory
        attribute :marker, :aliases => 'Marker'
        attribute :next_marker, :aliases => 'NextMarker'
        attribute :max_results, :aliases => ["MaxResults"]
        attribute :prefix, :aliases => ['Prefix']
        
        alias :common_prefixes :blob_prefixes #Compatibility with AWS
        
        model Fog::Storage::Azure::File
        
        def all(options = {})
          requires :directory
          options = {
            'delimiter' => delimiter,
            'marker' => marker,
            'MaxResults' => max_results,
            'prefix' => prefix
          }.merge! stringify_keys(options)
          options = options.reject{ |key, value| value.nil? || value.to_s.empty? }
          merge_attributes(options)
          
          parent = directory.collection.get(
            directory.key,
            options
          )
          if parent
            merge_attributes(parent.files.attributes)
            load(parent.files.map{ |file| file.attributes })
          else
            nil
          end
        end
        
        def get(key, options = {}, &block)
          
        end
        
        alias :each_file_this_page :each
        def each
          if block_given?
            subset = dup.all
            subset.each_file_this_page { |f| yield f }
            while subset.next_marker != nil
              subset = subset.all(marker: subset.next_marker)
              subset.each_file_this_page { |f| yield f }
            end
          end
          self
        end
        
      end
    end
  end
end