# MongoidUserstamp [![Build Status](https://secure.travis-ci.org/tbpro/mongoid_userstamp.png)](https://travis-ci.org/tbpro/mongoid_userstamp) [![Code Climate](https://codeclimate.com/github/tbpro/mongoid_userstamp.png)](https://codeclimate.com/github/tbpro/mongoid_userstamp)

MongoidUserstamp adds stamp columns for created by and updated by
informations within rails applications. Mongoid requires a ruby 
version above 1.8, so i've written the gem on the new 1.9 hash syntax.

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

## Credits

Copyright (c) 2012-2013 Thomas Boerger Programmierung <http://www.tbpro.de>
