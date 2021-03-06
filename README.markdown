# Whereabouts

Whereabouts is a Rails plugin that generates a polymorphic address model
to be associated to ActiveRecord models.

To install on Rails  add this to your Gemfile

    gem 'whereabouts'

Generate the base address class and migration

    rails g address

Run migrations

    rake db:migrate

If you have the [Ruby Geocoder](http://www.rubygeocoder.com) specified in
your project's Gemfile, adding {:geocode => true} to the has_whereabouts
definition will automatically geocode and populate the latitude and
longitude fields for the record.

# Examples

## Basic use:

    class Thing < ActiveRecord::Base
      has_whereabouts
    end

    t = Thing.new
    t.build_address

## Multiple addresses on same model:

    class Foo < ActiveRecord::Base
      has_whereabouts :shipping_address
      has_whereabouts :mailing_address
    end

    f = Foo.new
    f.build_shipping_address
    f.build_mailing_address

## Validating Presence of Attributes

    # Add :validate => [] to the option
    # hash on the call to has_whereabouts.
    # Options available in the array are
    # :line1, :line2, :city, :state, :zip
    class Thing < ActiveRecord::Base
      has_whereabouts :location, {:validate => [:city, :state, :zip]}
    end

## Automatic Geocoding

    # Must have Ruby Geocoder installed
    # and configured.  Will populate the
    # latitude and longitude attributes
    # on the Address
    class Thing < ActiveRecord::Base
      has_whereabouts :location, {:geocode => true}
    end

Contributing to whereabouts
=========

  * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
  * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
  * Fork the project
  * Start a feature/bugfix branch
  * Commit and push until you are happy with your contribution
  * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
  * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright (c) 2017 [Nicholas Fine](http://ndfine.com), released under the MIT license

