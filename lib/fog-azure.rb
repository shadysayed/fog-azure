require "fog-azure/version"
require "fog/core"
require "fog/storage_monkey_patch"


module Fog
  module Azure
    extend Fog::Provider
    service :storage, 'azure/storage', 'Storage'
    def self.test
      "hello"
    end
  end
end
