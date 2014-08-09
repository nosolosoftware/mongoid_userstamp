# -*- encoding : utf-8 -*-
class Post
  include Mongoid::Document
  include Mongoid::Userstamp

  mongoid_userstamp user_model: 'Admin',
                    created_name: :writer,
                    updated_name: :editor

  field :title
end