class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :zip
      t.references :addressable, :polymorphic => true
      t.timestamps
    end

    add_index :addresses, :addressable_type
    add_index :addresses, :addressable_id
  end

  def self.down
    drop_table :addresses
  end
end
