# frozen_string_literal: true

class Admin
  include Mongoid::Document
  include Mongoid::Userstamp::User

  field :name
end
