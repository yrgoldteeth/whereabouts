module Whereabouts
  extend ActiveSupport::Concern

  module ClassMethods
    # Accepts a symbol that will define the inherited 
    # type of Address.  Defaults to the parent class.
    def has_whereabouts klass=:address, options={}
      # extend Address with class name if not defined.
      unless Object.const_defined?(klass.to_s.camelize) || klass == :address
        create_address_class(klass.to_s.camelize)
      end

      # Set the has_one relationship and accepts_nested_attributes_for.  
      has_one klass, :as => :addressable, :dependent => :destroy
      accepts_nested_attributes_for klass

      # Define a singleton on the class that returns an array
      # that includes the address fields to validate presence of 
      # or an empty array
      validate_singleton = "#{klass.to_s}_whereabouts_validate_fields".to_sym
      if options[:validate] && options[:validate].is_a?(Array)
        set_validators(klass, options[:validate])
        define_singleton_method validate_singleton do options[:validate] end
      else
        define_singleton_method validate_singleton do [] end
      end

      # Check for geocode in options and confirm geocoder is defined.
      # Also defines a singleton to return a boolean about geocoding.
      geocode_singleton = "#{klass.to_s}_whereabouts_geocode?".to_sym
      if options[:geocode] && options[:geocode] == true && defined?(Geocoder)
        set_geocoding(klass)
        define_singleton_method geocode_singleton do true end
      else
        define_singleton_method geocode_singleton do false end
      end
    end

    # Sets validates_presence_of fields for the Address based on the 
    # singleton method created on the Address addressable_type class.
    private
    def set_validators klass, fields=[]
      _single = "#{klass.to_s}_whereabouts_validate_fields".to_sym
      klass.to_s.camelize.constantize.class_eval do
        fields.each do |f|
          validates_presence_of f, :if => lambda {|a| a.addressable_type.constantize.send(_single).include?(f)}
        end
      end
    end

    # If defined, geocode the address.
    def set_geocoding klass
      _single = "#{klass.to_s}_whereabouts_geocode?".to_sym
      klass.to_s.camelize.constantize.class_eval do
        geocoded_by :geocode_address
        after_validation :geocode, :if => lambda {|a| a.addressable_type.constantize.send(_single) && (a.new_record? || a.changed?)}
      end
    end

    # Generate a new class using Address as the superclass.  
    # Accepts a string defining the inherited type.
    def create_address_class(class_name, &block)
      klass = Class.new Address, &block
      Object.const_set class_name, klass
    end
  end
end
# Include the modules into ActiveRecord::Base
class ActiveRecord::Base
  include Whereabouts
end
