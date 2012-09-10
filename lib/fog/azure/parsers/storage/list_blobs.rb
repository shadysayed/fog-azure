module Fog
  module Parsers
    module Storage
      module Azure
        class ListBlobs < Fog::Parsers::Base
          def reset
            @blob = {}
            @response = {'Content' => [], 'BlobPrefixes' => []}
          end
          
          def start_element(name, attrs = [])
            super
            case name
            when 'Blob'
              @in_blob = true
            when 'Metadata'
              @in_metadata = true
              @blob['Metadata'] ||= {}
            when 'BlobPrefix'
              @in_blob_prefix = true
            end
          end
          
          def in_blob_directly?
            in_blob? && !(@in_metadata || @in_blob_prefix)
          end
          
          def in_blob?
            @in_blob
          end
          
          def in_root?
            !(in_blob? || @in_blob_prefix)
          end
          
          
          def end_element(name)
            case name
             when "Blob"
               unless @in_metadata
                 @response['Content'] << @blob
                 @blob = {}
                 @in_blob = false
               end
             when "Name", "Url", "Etag", "Snapshot", "Content-Type"
               @blob[name] = value if in_blob_directly?
             when "Last-Modified"
               @blob[name] = Time.parse(value) if in_blob_directly?
             when "Content-Length"
               @blob[name] = value.to_i if in_blob_directly?
             when "Prefix", "Marker", "NextMarker", "MaxResults", "Delimiter"
               @response[name] = value if in_root?
             when 'Metadata'
               @in_metadata = false
             when 'BlobPrefix'
               @in_blob_prefix = false
             end
            
            if @in_metadata
               @blob['Metadata'][name] = value
             elsif @in_blob_prefix && name == 'Name'
               @response['BlobPrefixes'] << value
             end
          end
        end
      end
    end
  end
end
