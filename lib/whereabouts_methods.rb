require 'active_record'

# Whereabouts

module Yrgoldteeth
  module Has
    module Whereabouts

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_whereabouts
          has_one :address, :as => :addressable, :dependent => :destroy
          accepts_nested_attributes_for :address
          extend Yrgoldteeth::Has::Whereabouts::SingletonMethods
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
