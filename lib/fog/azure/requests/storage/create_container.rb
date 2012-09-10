module Fog
  module Storage
    class Azure
      class Real
        def create_container(key, options = {})
          request(
            expects: [201],
            path: key,
            method: 'PUT',
            headers: options,
            query: {
              'restype' => 'container'
            }
          )
        end
      end
      class Mock
        def create_container(key, options = {})
        end
      end
    end
  end
end
