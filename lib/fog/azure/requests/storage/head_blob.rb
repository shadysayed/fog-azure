module Fog
  module Storage
    class Azure
      class Real
        def head_blob(container, path, options = {}, &block)
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
          
          if block_given?
            params[:response_block] = Proc.new
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
        def head_blob(container, path, options = {}, &block)
        end
      end
    end
  end
end