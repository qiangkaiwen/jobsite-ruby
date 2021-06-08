class State < ActiveRecord::Base
    has_many    :jobs
    has_many    :hires
    accepts_nested_attributes_for :jobs, :allow_destroy => true
    accepts_nested_attributes_for :hires, :allow_destroy => true
end
