# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Userstamp::User

  field :name
end
