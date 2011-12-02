module Whereabouts
  extend ActiveSupport::Concern

  module ClassMethods
    # Accepts a symbol that will define the inherited 
    # type of Address.  Defaults to the parent class.
    def has_whereabouts klass=:address, options={}
      # extend Address with class name if not defined.
      unless klass == :address || Object.const_defined?(klass.to_s.camelize)
        create_address_class(klass.to_s.camelize)
      end

      # Set the has_one relationship and accepts_nested_attributes_for.  
      has_one klass, :as => :addressable, :dependent => :destroy
      accepts_nested_attributes_for klass

      # Define a singleton on the class that returns an array
      # that includes the address fields to validate presence of 
      # or an empty array
      if options[:validate] && options[:validate].is_a?(Array)
        validators = options[:validate]
        set_validators(klass, validators)
      else
        validators = []
      end
      define_singleton_method validate_singleton_for(klass) do validators end

      # Check for geocode in options and confirm geocoder is defined.
      # Also defines a singleton to return a boolean about geocoding.
      if options[:geocode] && options[:geocode] == true && defined?(Geocoder)
        geocode = true
        set_geocoding(klass)
      else
        geocode = false
      end
      define_singleton_method geocode_singleton_for(klass) do geocode end
    end

    private
    # Accepts a symbol defining the class and 
    # returns a symbol to define a singleton
    # on the class like :address_whereabouts_geocode?
    def geocode_singleton_for klass
      "#{klass.to_s}_whereabouts_geocode?".to_sym
    end

    # Accepts a symbol defining the class and 
    # returns a symbol to define a singleton
    # on the class like :address_whereabouts_validate_fields
    def validate_singleton_for klass
      "#{klass.to_s}_whereabouts_validate_fields".to_sym
    end
    
    # Sets validates_presence_of fields for the Address based on the 
    # singleton method created on the Address addressable_type class.
    def set_validators klass, fields=[]
      _single = validate_singleton_for(klass)
      klass.to_s.camelize.constantize.class_eval do
        fields.each do |f|
          validates_presence_of f, 
            :if => lambda {|a| a.addressable_type.constantize.send(_single).include?(f)}
        end
      end
    end

    # Geocode the address using Address#geocode_address if the 
    # geocode_singleton is true and the record is either new or
    # has been updated.
    def set_geocoding klass
      _single = geocode_singleton_for(klass)
      klass.to_s.camelize.constantize.class_eval do
        geocoded_by :geocode_address
        after_validation :geocode, 
          :if => lambda {|a| a.addressable_type.constantize.send(_single) && (a.new_record? || a.changed?)}
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
# Include the module into ActiveRecord::Base
class ActiveRecord::Base
  include Whereabouts
end
