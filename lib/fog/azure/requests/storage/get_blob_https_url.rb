module Fog
  module Storage
    class AWS

      module GetBlobHttpsUrl

        def get_blob_https_url(container_name, blob_name, expires = nil, options = {})
          unless container_name
            raise ArgumentError.new('container_name is required')
          end
          unless blob_name
            raise ArgumentError.new('blob_name is required')
          end
          host, path = [@host, ::File.join(container_name, blob_name)]
          https_url({
            :headers  => {},
            :host     => host,
            :port     => 443,
            :method   => 'GET',
            :path     => path,
            :query    => options[:query]
          }, expires)
        end

      end

      class Real

        include GetBlobHttpsUrl

      end

      class Mock # :nodoc:all

        include GetBlobHttpsUrl

      end
    end
  end
end
