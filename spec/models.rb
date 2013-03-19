class User
  include Mongoid::Document
  include Mongoid::Userstamp::User
  field :name
end

class Author
  include Mongoid::Document
  field :name
end

class Book
  include Mongoid::Document
  include Mongoid::Userstamp
  field :name
end
