# MongoidUserstamp [![Build Status](https://secure.travis-ci.org/tbpro/mongoid_userstamp.png)](https://travis-ci.org/tbpro/mongoid_userstamp) [![Code Climate](https://codeclimate.com/github/tbpro/mongoid_userstamp.png)](https://codeclimate.com/github/tbpro/mongoid_userstamp)

MongoidUserstamp adds stamp columns for created by and updated by
information within Rails applications using Mongoid ORM.

## Version Support

MongoidUserstamp is tested on the following versions:

* Ruby 1.9.3 and 2.0.0
* Rails 3
* Mongoid 3

## Install

```ruby
  gem 'mongoid_userstamp'
```

## Usage

```ruby
  # Default config
  Mongoid::Userstamp.config do |c|

    # Default config values

    c.user_reader = :current_user
    c.user_model = :user

    c.created_column = :created_by
    c.created_accessor = :creator

    c.updated_column = :updated_by
    c.updated_accessor = :updater

    # Optional config values

    # c.created_alias = :c
    # c.updated_alias = :u
  end

  # Example model
  class Person
    include Mongoid::Document
    include Mongoid::Userstamp
  end
 
  # Create instance
  p = Person.create

  # Updater ObjectID or nil
  p.updated_by
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  # Updater instance or nil
  p.updater
  # => <User _id: 4f7c719f476da850ba000039>

  # Set updater manually (usually not required)
  p.updater = my_user # can be a Mongoid::Document or a BSON::ObjectID
  # => sets updated_by to my_user's ObjectID

  # Creator ObjectID or nil
  p.created_by
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  # Creator instance or nil
  p.creator
  # => <User _id: 4f7c719f476da850ba000039>

  # Set creator manually (usually not required)
  p.creator = my_user # can be a Mongoid::Document or a BSON::ObjectID
  # => sets created_by to my_user._id
```
## Multiple Configurations

Mongoid::Userstamp provides ability to create multiple configurations. Simply create a new configuration as:

```ruby
  # Admin config
  Mongoid::Userstamp.config :admin do |c|

    # Admin specific config values
    # Defaults are considered for values not specified.

    c.user_reader = :current_admin
    c.user_model = :admin

  end
```

Now to use this configuration instead of the default in any model use 'mongoid_userstamp' class method to specify configuration.

```
  # Example model
  class Book
    include Mongoid::Document
    include Mongoid::Userstamp

    # specifying the configuration to be used. If none then :default configuration is used.
    mongoid_userstamp :admin
  end

  # Create instance
  b = Book.create

  b.updater = <Admin _id: 4f7c719f476da850ba000039>

  b.updated_by
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  b.updater
  # => <Admin _id: 4f7c719f476da850ba000039>
```

## Contributing

Fork -> Patch -> Spec -> Push -> Pull Request

Please use Ruby 1.9.3 hash syntax, as Mongoid 3 requires Ruby >= 1.9.3

## Authors

* [Thomas Boerger](http://www.tbpro.de)
* [John Shields](https://github.com/johnnyshields)
* [Bharat Gupta](https://github.com/Bharat311)

## Copyright

Copyright (c) 2012-2013 Thomas Boerger Programmierung <http://www.tbpro.de>

Licensed under the MIT License (MIT). Refer to LICENSE for details.
