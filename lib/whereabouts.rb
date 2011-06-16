# Whereabouts
require 'whereabouts_methods'
module Whereabouts
  module Rails
    class Railtie < ::Rails::Railtie
      unless File.exist?('app/models/address.rb')
        puts 'NOTICE: Please run rails generate address for whereabouts gem'
      end
    end
  end
end
