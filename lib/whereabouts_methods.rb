# **Whereabouts** is a Rails plugin that generates a polymorphic, inheritable
# Address model.  Install it as a Rails plugin (Rails 3.x+ required)  
#
#     rails plugin install http://github.com/yrgoldteeth/whereabouts.git
#
# The most simple use case creates a has_one relationship with
# a generic Address: 
#
#     class Foo < ActiveRecord::Base
#       has_whereabouts
#     end
#     
#     f = Foo.new
#     f.build_address
#
# Also, a model can have any number of different inherited types of Addresses,
# i.e. shipping address and mailing address  
#
#     class Foo < ActiveRecord::Base
#       has_whereabouts :shipping
#       has_whereabouts :mailing
#     end
#     
#     f = Foo.new
#     f.build_shipping
#     f.build_mailing
#
# If you have the [Ruby Geocoder](http://www.rubygeocoder.com) specified in
# your project's Gemfile, adding {:geocode => true} to the has_whereabouts
# definition will automatically geocode and populate the latitude and
# longitude fields for the record.
#
#     class Foo < ActiveRecord::Base
#       has_whereabouts :shipping, {:geocode => true}
#     end
#
# You can see the source on [github](https://github.com/yrgoldteeth/whereabouts), and
# this page was generated with the wonderful
# [rocco](http://rtomayko.github.com/rocco/) documentation generator.  

# Hey, that's [me](http://ndfine.com)
module Yrgoldteeth
  # **Whereabouts**
  module Has
    module Whereabouts

      # Extend the ClassMethods module
      def self.included(base)
        base.extend ClassMethods
      end

      # **ClassMethods**
      module ClassMethods
        # Accepts a symbol that will define the inherited 
        # type of Address.  Defaults to the parent class.
        def has_whereabouts klass=:address, options={}
          unless klass == :address
            create_address_class(klass.to_s.camelize)
          end
          
          # Set the has_one relationship and accepts_nested_attributes_for.  
          has_one klass, :as => :addressable, :dependent => :destroy
          accepts_nested_attributes_for klass

          # Check for fields to validate
          # options[:validate] should be an array of symbols that match
          # attributes to validates_presence_of on the Address.
          # Define Class.validate_#{klass)_whereabouts? in the event that 
          # multiple models share the same Address class but validations
          # are not required for all instances.
          _singleton = "validate_#{klass.to_s}_whereabouts?".to_sym
          if options[:validate]
            set_validators(klass, options[:validate])
            define_singleton_method _singleton do true end
          else
            define_singleton_method _singleton do false end
          end

          # Check for geocode in options
          # and confirm geocoder is defined
          if options[:geocode] && options[:geocode] == true && defined?(Geocoder)
            set_geocoding(klass)
          end
        end

        # Sets validates_presence_of fields for the Address based on the 
        # validate_#{klass}_whereabouts? singleton method created on the Address'
        # addressable_type class.
        def set_validators klass, fields=[]
          _singleton = "validate_#{klass.to_s}_whereabouts?".to_sym
          klass.to_s.camelize.constantize.class_eval do
            fields.each do |f|
              validates_presence_of f, :if => lambda {|a| a.addressable_type.constantize.send _singleton}
            end
          end
        end

        # If defined, geocode the address.
        def set_geocoding klass
          klass.to_s.camelize.constantize.class_eval do
            geocoded_by :geocode_address
            after_validation :geocode, :if => lambda {|o| o.new_record? || o.changed?}
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
  end
end
# Include the modules into ActiveRecord::Base
ActiveRecord::Base.send(:include, Yrgoldteeth::Has::Whereabouts)
