$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'active_record'
require 'active_support'
require 'whereabouts_methods'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Build some dummy AR classes

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

def setup_test_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :zip
      t.string :type
      t.float  :latitude
      t.float  :longitude
      t.references :addressable, :polymorphic => true
      t.timestamps
    end
    create_table :customers do |t|
      t.timestamps
    end
    create_table :competitors do |t|
      t.timestamps
    end
  end
end

def teardown_test_db
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.drop_table(t)
  end
end

class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
end

class Customer < ActiveRecord::Base
  has_whereabouts :address
  has_whereabouts :test_address, :validate => [:line1, :city, :state, :zip]
end

class Competitor < ActiveRecord::Base
  has_whereabouts :test_address, :validate => [:city, :state, :zip]
end

RSpec.configure do |config|
end
