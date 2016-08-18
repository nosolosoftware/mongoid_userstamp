# -*- encoding : utf-8 -*-
class User
  include Mongoid::Document
  include Mongoid::Userstamp::UserstampUser

  field :name
end
