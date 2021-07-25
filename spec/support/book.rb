# frozen_string_literal: true

class Book
  include Mongoid::Document
  include Mongoid::Userstamp

  userstamp user_class_name: 'User'

  field :name
end
