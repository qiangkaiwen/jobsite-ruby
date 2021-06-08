class Hire < ActiveRecord::Base
    belongs_to  :user
    belongs_to  :job
    belongs_to  :state
    has_many    :chats

    accepts_nested_attributes_for :user, :allow_destroy => true
    accepts_nested_attributes_for :job, :allow_destroy => true
    accepts_nested_attributes_for :state, :allow_destroy => true
    accepts_nested_attributes_for :chats, :allow_destroy => true
end
