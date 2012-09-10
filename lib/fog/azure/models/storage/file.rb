require 'fog/core/model'
# require 'fog/azure/models/storage/version'

module Fog
  module Storage
    class Azure
      class File < Fog::Model
        
        identity :key, :aliases => 'Name'
        
        attr_writer :body
        attribute :cache_control,       :aliases => 'Cache-Control'
        # attribute :content_disposition, :aliases => 'Content-Disposition'
        attribute :content_encoding,    :aliases => 'Content-Encoding'
        attribute :content_length,      :aliases => ['Content-Length', 'Size'], :type => :integer
        attribute :content_md5,         :aliases => 'Content-MD5'
        attribute :content_type,        :aliases => 'Content-Type'
        attribute :etag,                :aliases => ['Etag', 'ETag']
        attribute :expires,             :aliases => 'Expires'
        attribute :last_modified,       :aliases => ['Last-Modified', 'LastModified'], :type => :time
        
        # Block size for the using the block api
        # Use small sizes to conserve memory (the max allowed by API is 4 Megs)
        attr_accessor :block_size
        
        def body
          attributes[:body] ||= if last_modified && (file = collection.get(identity))
            file.body
          else
            ''
          end
        end
        
        def body=(new_body)
          attributes[:body] = new_body
        end
        
        def directory
          @directory
        end
        
        
        def copy(target_directory_key, target_file_key, options ={})
          
        end
        
        def destroy(options = {})
          
        end
        
        def save(options = {})
          
        end
        
        private
        
        def directory=(new_directory)
          @directory = new_directory
        end
        
        def save_with_blocks(options)
          
        end
        
      end
    end
  end
end