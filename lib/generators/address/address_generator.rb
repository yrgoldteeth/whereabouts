require 'rails/generators/migration'

class AddressGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  class << self
    def source_root
      @whereabouts_source_root ||= File.expand_path('../templates', __FILE__)
    end

    def next_migration_number path
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end
  end

  def create_model_file
    template 'address.rb', 'app/models/address.rb'
    migration_template 'create_addresses.rb', 'db/migrate/create_addresses.rb'
  end
end
