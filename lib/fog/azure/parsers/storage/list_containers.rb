module Fog
  module Parsers
    module Storage
      module Azure
        class ListContainers < Fog::Parsers::Base
          def reset
            @container = {}
            @response = {'Containers' => []}
          end
          
          def end_element(name)
            case name
            when "Container"
              @response['Containers'] << @container
              @container = {}
            when "Name", "Url", "Etag"
              @container[name] = value
            when "Last-Modified"
              @container[name] = Time.parse(value)
              #when "MaxResults"
            when "NextMarker"
              @response[name] = value
            end
          end
        end
      end
    end
  end
end