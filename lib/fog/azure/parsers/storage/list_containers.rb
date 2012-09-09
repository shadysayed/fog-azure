module Fog
  module Parsers
    module Storage
      module Azure
        class ListContainers < Fog::Parsers::Base
          def reset
            @container = {}
            @response = {'Containers' => []}
          end
          
          def start_element(name, attrs = [])
            super
            case name
            when 'Metadata'
              @in_metadata = true
              @container['Metadata'] ||= {}
            end
          end
          
          def end_element(name)
            case name
            when "Container"
              unless @in_metadata
                @response['Containers'] << @container
                @container = {}
              end
            when "Name", "Url", "Etag"
              @container[name] = value unless @in_metadata
            when "Last-Modified"
              @container[name] = Time.parse(value) unless @in_metadata
              #when "MaxResults"
            when "Prefix", "Marker", "NextMarker", "MaxResults"
              @response[name] = value unless @in_metadata
            when 'Metadata'
              @in_metadata = false
            end
            
            if @in_metadata
              @container['Metadata'][name] = value
            end
          end
        end
      end
    end
  end
end