require 'active_record'

# Whereabouts

module Yrgoldteeth
  module Has
    module Whereabouts

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        #
        # Accepts a symbol that will define the inherited 
        # type of Address.  Defaults to the parent class.
        # Accepts a hash to define geocoding options
        def has_whereabouts klass=:address, options={}
          unless klass == :address
            create_address_class(klass.to_s.classify)
          end
          has_one klass, :as => :addressable, :dependent => :destroy
          accepts_nested_attributes_for klass
          extend Yrgoldteeth::Has::Whereabouts::SingletonMethods
        end
        
        # 
        # Accepts a string defining the inherited Address
        # type
        def create_address_class(class_name, &block)
          klass = Class.new Address, &block
          Object.const_set class_name, klass
        end
      end

      module SingletonMethods
        # Helper method to lookup address for given object
        # Equivalent to obj.address
        def get_address_for obj
          addressable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s

          Address.find(:last, :conditions => ["addressable_id = ? and addressable_type = ?", obj.id, addressable])
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Yrgoldteeth::Has::Whereabouts)
