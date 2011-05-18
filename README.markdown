Whereabouts
===========

Whereabouts is a Rails plugin that generates a polymorphic address model
to be associated to ActiveRecord models.  

To install on Rails 3.x
    rails plugin install http://github.com/yrgoldteeth/whereabouts.git

To install on Rails 2.3.x (no longer under development)
    script/plugin install http://github.com/yrgoldteeth/whereabouts.git -r 2.3x

Generate files on Rails 3.x
    rails g address

Generate files on Rails 2.3.x
    script/generate address

Run migrations
    rake db:migrate


Example
=======

    class Thing < ActiveRecord::Base
      has_whereabouts
    end

    t = Thing.new
    t.build_address


Copyright (c) 2011 Nicholas Fine, released under the MIT license
v0.1.0

