class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  ZIP_REGEX   = /^\d{5}([\-]\d{4})?$/

  validates_presence_of :line1, :city, :state, :zip
  validates_format_of :zip, :with => ZIP_REGEX, :message => 'is invalid'
end

