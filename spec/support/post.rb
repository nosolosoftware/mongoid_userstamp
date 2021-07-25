# frozen_string_literal: true

class Post
  include Mongoid::Document
  include Mongoid::Userstamp

  userstamp user_class_name: 'Admin',
            created_by_field: :writer,
            updated_by_field: :editor

  field :title
end
