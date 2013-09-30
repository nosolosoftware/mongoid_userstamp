# Changelog

## 0.3.0 - Unreleased

* BREAKING CHANGE: Default value for `updated_accessor` was `:updator`, is now `:updater`, since "updator" is not an English word (@johnnyshields)
* DEPRECATION: #configure` is now an alias `#config` and is deprecated (@johnnyshields)
* Replace `Mongoid::Userstamp.configuration` and `Mongoid::Userstamp.configure` with `#config`, which is both a getter and a setter (@johnnyshields)
* Replace usages of `id` with `_id`, since there are many gems which override the behavior of `id`, for example mongoid_slug (@johnnyshields)
* Do not overwrite creator if it has already been set manually (@johnnyshields)
* Define setter methods for updated_accessor/created_accessor which assign the user id. Accepts both `Mongoid::Document` and `BSON::ObjectID` types. (@johnnyshields)
* Allow pass-in of Mongoid field opts for updated_column/created_column. Useful to set field aliases, default value, etc. (@johnnyshields)
* Expose current_user as `Mongoid::Userstamp.current_user` (@johnnyshields)
* Field type is now `::Moped::BSON::ObjectID` instead of Object (@johnnyshields)
* Catch error if creator/updater has been deleted and return nil (@johnnyshields)
* Query for creator/updater user using `unscoped` (@johnnyshields)
* Improve code readability (@johnnyshields)
* Improve test coverage, including adding tests for config (@johnnyshields)

## 0.2.0 - 2013-03-24

* Added some specs for test coverage
* Removed dependecy for `Mongoid::Timestamps`
