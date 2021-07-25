# Changelog

## [0.5.0](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.5.0) - 2014-07-26

* BREAKING: API method renaming
  * `GlobalConfig.created_name` --> `created_by_field`
  * `GlobalConfig.updated_name` --> `updated_by_field`
  * `Model.mongoid_userstamp` --> `userstamp`
    * option `:created_name` --> `:created_by_field`
    * option `:updated_name` --> `:updated_by_field`
  * `User.mongoid_userstamp_user` --> `userstamp_user`
    * option `:reader` --> `:controller_current_user`
  * `User.current` --> `current_user` / `current_user=` / `current_user?`
  * Method renaming done for clarity and consistency. Refer to updated documentation

* Improvement
  * Raise error if invalid options are supplied to core `userstamp` and `userstamp_user` functions.
  * Add Rubocop config.
  * Replace Travis CI with Github Actions.

## [0.4.1](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.4.1) - 2014-08-21

* Improvement
  * Do not overwrite the `updater` if has been manually set (i.e. is in a dirty state.)
  * Add specs for Rails 4/Mongoid 4

* Documentation
  * Document `User.do_as` feature.


## [0.4.0](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.4.0) - 2014-02-24

* Improvement
  * BREAKING: Change userstamp keys to use Mongoid relations. This will change the underlying database field names, and as such will require a migration.
  * BREAKING: Do not include Mongoid::Userstamp in "User" class by default.
  * Mongoid::Userstamp config initializer is now optional.
  * Add support for multiple user classes.
  * Add class-level config override capability for both users and userstamped model classes.
  * Add automatic support for `RequestStore` gem as drop-in replacement for `Thread.current`
* Refactor
  * DEPRECATION: `created_column` config is now `created_by_field`
  * DEPRECATION: `created_updated` config is now `created_updated`
  * DEPRECATION: `user_class_name` config is no longer used. Instead, include Mongoid::Userstamp::User in your user model.
  * Substantial refactoring of all classes and test cases. Among other changes, all access to `Thread.current` variables is now done in the Mongoid::Userstamp module singleton.

## [0.3.2](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.3.2) - 2014-01-12

* Fix bad gem release

## [0.3.1](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.3.1) - 2014-01-11

* Improvement
  * Remove autoload and replace with require in gem root lib file
  * Add log warning for `#configure` deprecation

* Admin
  * Remove Jeweler dependency, replace with gem-release gem
  * Add Gemfile.lock to .gitignore (best practice for gems)
  * Simplify version file

## [0.3.0](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.3.0) - 2013-10-02

* Improvement
  * BREAKING: Default value for `updated_accessor` was `:updator`, is now `:updater` (@johnnyshields)
  * DEPRECATION: `#configure` is now an alias for `#config` and is deprecated (@johnnyshields)
  * Replace `Mongoid::Userstamp.configuration` and `Mongoid::Userstamp.configure` with `#config` (@johnnyshields)
  * Replace usages of `id` with `_id`, since there are many gems which override the behavior of `id` (@johnnyshields)
  * Do not overwrite creator if it has already been set manually (@johnnyshields)
  * Define setter methods for updated_accessor/created_accessor which assign the user id. Accepts both `Mongoid::Document` and `BSON::ObjectID` types (@johnnyshields)
  * Allow pass-in of Mongoid field options for updated_column/created_column. Useful to set field aliases, default value, etc. (@johnnyshields)
  * Expose current_user as `Mongoid::Userstamp.current_user` (@johnnyshields)
  * Field type is now `::Moped::BSON::ObjectID` instead of Object (@johnnyshields)
  * Query for creator/updater user using `unscoped` (@johnnyshields)
  * Improve code readability (@johnnyshields)
  * Improve test coverage, including adding tests for config (@johnnyshields)

* Bugfix
  * Catch error if creator/updater has been deleted and return nil (@johnnyshields)

## [0.2.1](https://github.com/tablecheck/mongoid_userstamp/releases/tag/v0.2.1) - 2013-03-24

* Improvement
  * Added some specs for test coverage (@johnnyshields)
  * Removed dependecy for `Mongoid::Timestamps` (@johnnyshields)
