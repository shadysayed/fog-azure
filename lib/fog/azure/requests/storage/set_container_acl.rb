module Fog
  module Storage
    class Azure
      class Real
        # no parser is needed we read from headers
        #require 'fog/azure/parsers/storage/get_container_properties'
        
        def set_container_acl(key, acl = nil, signed_identifiers = nil)
          
          unless ['container', 'blob', nil].include? acl
            raise Excon::Errors::BadRequest.new('invalid x-ms-blob-public-access')
          end
          # This operation will only nead to change the query string
          # So the options hash is passed to the query and not headers
          headers = {}
          body = ''
          if acl
            headers['x-ms-blob-public-access'] = acl
          end
          if signed_identifiers
            identifiers_xml = signed_identifiers.map{ |identifier|
              <<-XML
  <SignedIdentifier> 
    <Id>#{identifier.id}</Id>
    <AccessPolicy>
      <Start>#{identifier.access_policy.start}</Start>
      <Expiry>#{identifier.access_policy.expiry}</Expiry>
      <Permission>#{identifier.access_policy.permission}</Permission>
    </AccessPolicy>
  </SignedIdentifier>
XML
            }
            
            body = <<-XML
<?xml version="1.0" encoding="utf-8"?>
<SignedIdentifiers>
#{identifiers_xml}
</SignedIdentifiers>
XML
          end
          request(
          expects: 200,
          headers: headers,
          path: key,
          method: 'PUT',
          body: body,
          query: {
            'restype' => 'container',
            'comp' => 'acl'
            }#.merge!(options || {})
          )
        end
      end
      class Mock
        def set_container_acl(key, acl = nil, signed_identifiers = nil)
        end
      end
    end
  end
end