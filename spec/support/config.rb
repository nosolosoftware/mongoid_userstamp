Mongoid::Userstamp.config do |c|
  c.created_accessor = :writer
  c.updated_accessor = :editor
end

Mongoid::Userstamp.config(:admin) do |c|
  c.user_reader = :current_admin
  c.user_model = :admin

  c.created_column = :c_by
  c.updated_column = :u_by
end