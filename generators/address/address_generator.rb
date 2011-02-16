class AddressGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'app/models'
      m.file 'address.rb', 'app/models/address.rb'
      m.migration_template 'create_addresses.rb', 'db/migrate'
    end
  end

  def file_name
    'create_addresses'
  end
end

