module Fog
  module Storage
    class Azure
      class Real
        def delete_container(key)
          request(
            expects: [202],
            path: key,
            method: 'DELETE',
            query: {
              'restype' => 'container'
            }
          )
        end
      end
      class Mock
        def delete_container(key, options = {})
        end
      end
    end
  end
end
