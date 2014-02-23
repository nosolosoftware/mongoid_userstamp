# Mongoid::Userstamp [![Build Status](https://secure.travis-ci.org/tbpro/mongoid_userstamp.png)](https://travis-ci.org/tbpro/mongoid_userstamp) [![Code Climate](https://codeclimate.com/github/tbpro/mongoid_userstamp.png)](https://codeclimate.com/github/tbpro/mongoid_userstamp)

Mongoid::Userstamp adds stamp columns for created by and updated by
information within Rails applications using Mongoid ORM.

## Version Support

Mongoid::Userstamp is tested on the following versions:

* Ruby 1.9.3 and 2.0.0
* Rails 3
* Mongoid 3

## Install

```ruby
  gem 'mongoid_userstamp'
```

## Usage

Mongoid::Userstamp does the following:
* Defines Mongoid `belongs_to` relations to the user class for `created_by` and `updated_by` on each class where `Mongoid::Userstamp` is included
* Automatically tracks the current user via a `before_filter` (see Rails Integration below)
* Sets the `created_by` and `updated_by` values in `before_save` and `before_update` callbacks respectively on the target models.
* Adds methods to the user class to check for the current user.

```ruby
  # Default config (optional unless you want to customize the values)
  Mongoid::Userstamp.config do |c|
    c.user_reader = :current_user
    c.created_name = :created_by
    c.updated_name = :updated_by
  end

  # Example model class
  class Product
    include Mongoid::Document
    include Mongoid::Userstamp

    # optional class-level config override
    # mongoid_userstamp user_model: 'MyUser',
    #                   created_name: :creator,
    #                   updated_name: :updater,
  end
 
  # Example user class (you can skip this step you have a single user class is named "User")
  class MyUser
    include Mongoid::Document
    include Mongoid::Userstamp::User

    # optional class-level config override
    # mongoid_userstamp_user reader: :current_my_user
  end

  # Create instance
  p = Product.create

  # Creator ObjectID   |   Updater ObjectID
  p.created_by_id      |   p.updated_by_id
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  # Creator instance   |   Updater instance
  p.created_by         |   p.updated_by
  # => <User _id: 4f7c719f476da850ba000039>

  # Set creator/updater manually (usually not required)
  p.created_by = MyUser.where(name: 'Will Smith')
  p.updated_by = MyUser.where(name: 'DJ Jazzy Jeff')
```


## Rails Integration

Popular Rails authentication frameworks such as Devise and Sorcery make a `current_user` method available in
your Controllers. Mongoid::Userstamp will automatically use this to set its user reference in a `before_filter`
on each request. (You can set an alternative method name via the `user_reader` config.)

*Gotcha:* If you have special controller actions which change/switch the current user to a new user, you will
need to set `User.current = new_user` after the switch occurs.


## Thread Safety

Mongoid::Userstamp stores all-related user variables in `Thread.current`. If the
[RequestStore](https://github.com/steveklabnik/request_store) gem is installed, Mongoid::Userstamp
will automatically store variables in the `RequestStore.store` instead. RequestStore is recommended
for threaded web servers like Thin or Puma.


## Advanced Usage: Multiple User Classes

Most Rails apps use a single user model. However, Mongoid::Userstamp supports using multiple user models
at once, and will track a separate current_user for each class.

Please note that each model may subscribe to only one user type for its userstamps, set via the
`:user_model` option.

```ruby
  class Admin
    include Mongoid::Document
    include Mongoid::Userstamp::User

    mongoid_userstamp_user reader: :current_admin
  end

  class Customer
    include Mongoid::Document
    include Mongoid::Userstamp::User

    mongoid_userstamp_user reader: :current_customer
  end

  class Album
    include Mongoid::Document
    include Mongoid::Userstamp

    mongoid_userstamp user_model: 'Customer'
  end

  class Label
    include Mongoid::Document
    include Mongoid::Userstamp

    mongoid_userstamp user_model: 'Admin'
  end

  # Set current user for each type
  Admin.current = Admin.where(name: 'Biz Markie')
  Customer.current = Customer.where(name: 'Sir Mix-A-Lot')

  # In your Controller action
  album = Album.new('Baby Got Back Single')
  album.save!
  album.created_by.name   #=> 'Sir Mix-A-Lot'

  label = Label.new('Cold Chillin Records')
  label.save!
  label.created_by.name   #=> 'Biz Markie'
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
