# encoding: utf-8
require 'spec_helper'
require 'fog-azure'

describe Fog::Storage::Azure do
  
  it "Checks the keys" do
    connection = Fog::Storage.new(
      provider: :azure,
      azure_storage_account_name: ENV['AZURE_STORAGE_ACCOUNT_NAME'],
      azure_storage_secret_key: ENV['AZURE_STORAGE_SECRET_KEY']
    )
    dirs = connection.directories.all
    raise dirs.inspect
  end
  
end