class Category < ActiveRecord::Base
    has_many    :jobs
    accepts_nested_attributes_for :jobs, :allow_destroy => true
end
