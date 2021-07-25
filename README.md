# Mongoid::Userstamp

[![Build Status](https://github.com/tablecheck/mongoid_userstamp/actions/workflows/test.yml/badge.svg?query=branch%3Amaster)](https://github.com/tablecheck/mongoid_userstamp/actions/workflows/test.yml?query=branch%3Amaster)
[![Gem Version](https://img.shields.io/gem/v/mongoid_userstamp.svg)](https://rubygems.org/gems/mongoid_userstamp)

Mongoid::Userstamp adds user relations for created_by and updated_by
within Rails applications using Mongoid.

## Version Support

Mongoid::Userstamp is tested on the following versions:

* Ruby 2.5+
* Rails 5.x+
* Mongoid 7.x+

For legacy support, please use an older version of Mongoid::Userstamp.

## Install

```ruby
gem 'mongoid_userstamp'
```

## Usage

Mongoid::Userstamp does the following:
* Defines Mongoid `belongs_to` relations to the user class for `created_by` and `updated_by` on each class where `Mongoid::Userstamp` is included
* Automatically tracks the current user via a `before_action` (see Rails Integration below)
* Sets the `created_by` and `updated_by` values in `before_save` and `before_update` callbacks respectively on the target models.
* Adds methods to the user class to check for the current user.

```ruby
  # Default config (optional unless you want to customize the values)
  Mongoid::Userstamp.config do |c|
    c.controller_current_user = :current_user
    c.created_by_field = :created_by
    c.updated_by_field = :updated_by
  end

  # Example model class
  class Product
    include Mongoid::Document
    include Mongoid::Userstamp

    # optional class-level config override
    # userstamp user_class_name: 'MyUser',
    #           created_by_field: :creator,
    #           updated_by_field: :updater,
  end
 
  # Example user class
  class MyUser
    include Mongoid::Document
    include Mongoid::Userstamp::User

    # optional class-level config override
    # userstamp_user controller_current_user: :current_my_user
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


## Preservation of Manually-set Values

Mongoid::Userstamp will not overwrite manually set values in the `created_by` and `updated_by` fields. Specifically:

* The `created_by` is only set during the creation of new models (`before_create` callback). Mongoid::Userstamp will not
overwrite the `created_by` field if it already contains a value (i.e. was manually set.)
* The `updated_by` is set each time the model is saved (`before_create` callback), which includes the initial
creation. Mongoid::Userstamp will not overwrite the `updated_by` field if it been modified since the last save, as
per Mongoid's built-in "dirty tracking" feature.


## Rails Integration

Popular Rails authentication frameworks such as Devise and Sorcery make a `current_user` method available in
your Controllers. Mongoid::Userstamp will automatically use this to set its user reference in a `before_action`
on each request. (You can set an alternative method name via the `controller_current_user` config.)

*Gotcha:* If you have special controller actions which change/switch the current user to a new user, you will
need to set `User.current_user = new_user` after the switch occurs.


## Thread Safety

Mongoid::Userstamp stores all-related user variables in `Thread.current`. If the
[RequestStore](https://github.com/steveklabnik/request_store) gem is installed, Mongoid::Userstamp
will automatically store variables in the `RequestStore.store` instead. RequestStore is recommended
for threaded web servers like Thin or Puma.


## Advanced Usage: Scoped Execution

It is possible to execute a block of code within the context of a given user as follows:

```ruby
User.current_user = staff
User.current_user  #=> staff

User.do_as(admin) do
  my_model.save!
  User.current_user  #=> admin
end

User.current_user  #=> staff
```


## Advanced Usage: Multiple User Classes

Most Rails apps use a single user model. However, Mongoid::Userstamp supports using multiple user models
at once, and will track a separate current_user for each class.

Please note that each model may subscribe to only one user type for its userstamps, set via the
`:user_class_name` option.

```ruby
  class Admin
    include Mongoid::Document
    include Mongoid::Userstamp::User

    userstamp_user controller_current_user: :current_admin
  end

  class Customer
    include Mongoid::Document
    include Mongoid::Userstamp::User

    userstamp_user controller_current_user: :current_customer
  end

  class Album
    include Mongoid::Document
    include Mongoid::Userstamp

    userstamp user_class_name: 'Customer'
  end

  class Label
    include Mongoid::Document
    include Mongoid::Userstamp

    userstamp user_class_name: 'Admin'
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

## About the Maintainers

Mongoid::Userstamp is made with ❤ by [TableCheck](https://www.tablecheck.com/en/join/),
the leading restaurant reservation and guest management app maker.
If **you** are a ninja-level 🥷 coder (Javascript/Ruby/Elixir/Python/Go),
designer, product manager, data scientist, QA, etc. and are ready to join us in Tokyo, Japan
or work remotely, please get in touch at [careers@tablecheck.com](mailto:careers@tablecheck.com).

## Authors

* [Thomas Boerger](http://www.tbpro.de)
* [John Shields](https://github.com/johnnyshields)
* [Bharat Gupta](https://github.com/Bharat311)

## Copyright

Copyright (c) 2012-2020 Thomas Boerger Programmierung <http://www.tbpro.de>
Copyright (c) 2021 TableCheck <http://www.tablecheck.com/en/join>

Licensed under the MIT License (MIT). Refer to LICENSE for details.
