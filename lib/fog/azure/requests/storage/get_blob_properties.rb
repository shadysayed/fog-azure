module Fog
  module Storage
    class Azure
      class Real
        def get_blob_properties(container, path, options = {})
          unless container
            raise ArgumentError.new("container is required")
          end
          unless path
            raise ArgumentError.new("path is required")
          end
          params = {headers: {}}
          if snapshot = options.delete('snapshot')
            params[:query] = {'snapshot' => snapshot}
          end
          
          
          request(params.merge!({
            expects: [200],
            method: 'HEAD',
            idempotent: true,
            path: File.join(container, path) # Fog::Rackspace.escape(path, '/'))
          }))
        end
      end
      class Mock
      end
    end
  end
end