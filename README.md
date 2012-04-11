# MongoidUserstamp [![Build Status](https://secure.travis-ci.org/Langwhich/mongoid_userstamp.png)](https://secure.travis-ci.org/Langwhich/mongoid_userstamp)

MongoidUserstamp adds stamp columns for created by and updated by
informations within rails applications.

## Install

 ```ruby
 gem 'mongoid_userstamp'
 ```

## Usage

 ```ruby
 # Default config
 Mongoid::Userstamp.configure do |c|
   c.user_reader = :current_user
   c.user_model = :user

   c.created_column = :created_by
   c.created_accessor = :creator

   c.updated_column = :updator_by
   c.updated_accessor = :updator
 end

 # Example model
 class Person
   include Mongoid::Document
   include Mongoid::Userstamp
 end
 
 # Create instance
 p = Person.create

 # Updater ObjectID or nil
 p.created_by
 # => BSON::ObjectId('4f7c719f476da850ba000039')

 # Updater instance or nil
 p.creator
 # => <User _id: 4f7c719f476da850ba000039>

 # Creater ObjectID or nil
 p.updated_by
 # => BSON::ObjectId('4f7c719f476da850ba000039')

 # Creater instance or nil
 p.updator
 # => <User _id: 4f7c719f476da850ba000039>
 ```

## Credits

Copyright (c) 2012 Langwhich GmbH <http://www.langwhich.com>
