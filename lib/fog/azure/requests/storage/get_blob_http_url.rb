module Fog
  module Storage
    class AWS

      module GetBlobHttpUrl

        def get_blob_http_url(container_name, blob_name, expires = nil, options = {})
          unless container_name
            raise ArgumentError.new('container_name is required')
          end
          unless blob_name
            raise ArgumentError.new('blob_name is required')
          end
          host, path = [@host, ::File.join(container_name, blob_name)]
          http_url({
            :headers  => {},
            :host     => host,
            :port     => 80,
            :method   => 'GET',
            :path     => path,
            :query    => options[:query]
          }, expires)
        end

      end

      class Real

        include GetBlobHttpUrl

      end

      class Mock # :nodoc:all

        include GetBlobHttpUrl

      end
    end
  end
end
