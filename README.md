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
    c.user_model = :user
    c.created_by_name = :created_by
    c.updated_by_name = :updated_by
    c.polymorphic = false
    c.use_request_store = false
  end

  # Example model
  class Product
    include Mongoid::Document
    include Mongoid::Userstamp
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
  p.created_by = User.where(name: 'Will Smith')
  p.updated_by = User.where(name: 'DJ Jazzy Jeff')
```


## Rails Integration

Popular Rails authentication frameworks such as Devise and Sorcery make a `current_user` method available in
your Controllers. Mongoid::Userstamp will automatically use this to set its user reference in a `before_filter`
on each request. (You can set an alternative method name via the `user_reader` config.)

*Gotcha:* If you have special controller actions which change/switch the current user to a new user, you will
need to set `Mongoid::Userstamp.current_user = new_user` after the switch occurs.


## Thread Safety

By default, Mongoid::Userstamp stores all-related user variables in `Thread.current`. This may cause
erratic behavior on threaded web servers like Thin or Puma. Fortunately you can use the
[RequestStore](https://github.com/steveklabnik/request_store) gem as workaround by installing the gem and
setting `use_request_store = true` in your config.


## Advanced Usage: Polymorphic Userstamps

In general, most Rails apps use a single user model. However, if you would like to use
Mongoid::Userstamp will track a separate current_user for each class.

Please be aware of the following limitations of this approach:
* Enabling `use_polymorphic = true` will make every userstamped class in your application
to be polymorphic.
* You will have to manually add the `created_by_type` and `updated_by_type` fields
if you were not using them previously.
* Although multiple user classes may be logged in at once, the userstamp contains only one value by design.
The assumption is that there is only one actual user/person who does the given create/update action.

```ruby
  # Example config for polymorphism
  Mongoid::Userstamp.config do |c|
    c.polymorphic = true

    c.user_config do |u|
      u.model  = :merchant_user
      u.reader = :current_merchant_user
    end

    c.user_config do |u|
      u.model  = :customer_user
      u.reader = :current_customer_user
    end
  end

  # Example model (same as non-polymorphic case)
  class Product
    include Mongoid::Document
    include Mongoid::Userstamp
  end

  # Set current user for each type
  Mongoid::Userstamp.current_user = CustomerUser.where(name: 'Sir Mix-A-Lot')
  Mongoid::Userstamp.current_user = MerchantUser.where(name: 'Biz Markie')

  # In your Controller action
  product = Product.new('Baby Got Back Single')
  Mongoid::Userstamp.user_class = 'customer_user'
  product.save!
  product.updated_by.name   #=> 'Sir Mix-A-Lot'
  product.updated_by_type   #=> 'CustomerUser'

  # Alternative block syntax
  Mongoid::Userstamp.with_user_class('merchant_user') do
    product.save!
    product.updated_by.name   #=> 'Biz Markie'
    product.updated_by_type   #=> 'MerchantUser'
  end
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
