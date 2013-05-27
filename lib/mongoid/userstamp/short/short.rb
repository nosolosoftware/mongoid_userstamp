# -*- encoding : utf-8 -*-
module Mongoid

    module Userstamp
    # Remove the column name, and replaces it by a shortened name, but keeps the old field name as an alias
        module Short
            extend ActiveSupport::Concern
            included do
                    puts '********SHORTENING******'
                    include  Mongoid::Userstamp
                    _column_created_by = "#{Mongoid::Userstamp.configuration.created_column.to_s}".to_sym
                    _column_updated_by = "#{Mongoid::Userstamp.configuration.updated_column.to_s}".to_sym
                    fields.delete(_column_created_by)
                    fields.delete(_column_updated_by)
                    #clean that
                    field :c_by, type: Object, as: Mongoid::Userstamp.configuration.created_column
                    field :u_by, type: Object, as: Mongoid::Userstamp.configuration.updated_column
            end
        end
    end
end
