module Fog
  module Storage
    class Azure
      class Real
        def get_container_acl(container)
          # TODO: We might need to make a parser or something for the full implementation
          request(
            path: container,
            method: :get,
            query:{
              'restype' => 'container',
              'comp' => 'acl'
            }
          )
        end
      end
      class Mock
        def get_container_acl(container)
          
        end
      end
    end
  end
end