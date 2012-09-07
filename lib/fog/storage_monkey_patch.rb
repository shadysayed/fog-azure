require "fog/storage"

module Fog
  module Storage
    class << self
      alias_method :new_without_azure, :new
      def new(attributes)
        attributes_copy = attributes.dup # prevent delete from having side effects just as in base
        case provider = attributes_copy.delete(:provider).to_s.downcase.to_sym
        when :azure
          require 'fog/azure/storage'
          Fog::Storage::Azure.new(attributes_copy)
        else
          new_without_azure(attributes)
        end
      end
    end
  end
end