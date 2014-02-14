# -*- encoding : utf-8 -*-
class Post
  include Mongoid::Document
  include Mongoid::Userstamp

  mongoid_userstamp :admin

  field :title
end