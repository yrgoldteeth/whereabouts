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
#       has_whereabouts :shipping_address
#       has_whereabouts :mailing_address
#     end
#     
#     f = Foo.new
#     f.build_shipping_address
#     f.build_mailing_address
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
        # Also sets the has_one relationship and accepts_nested_attributes_for.  
        # FIXME this is broken. :(
        def has_whereabouts klass=:address, options={}
          unless klass == :address
            create_address_class(klass.to_s.classify)
          end
          
          has_one klass, :as => :addressable, :dependent => :destroy
          accepts_nested_attributes_for klass

          # check for geocode in options
          # and confirm geocoder is defined
          if options[:geocode] && defined?(Geocoder)
            geocode_fields = options.fetch(:geocode_fields){[:city, :state, :zip]}
            set_geocoding(klass, geocode_fields)
          end
        end

        def set_geocoding klass=:address, geocode_fields
          klass.to_s.classify.constantize.class_eval do
            def geocode_address
              geocode_fields.map{|f| self.send(f).to_s}.join(', ')
            end
            
            geocoded_by :geocode_address
            after_validation :geocode
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
