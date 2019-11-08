# -*- encoding : utf-8 -*-
class Admin
  include Mongoid::Document
  include Mongoid::Userstamp::UserstampUser

  field :name
end