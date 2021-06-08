class Job < ActiveRecord::Base
    validates :title, presence: true
    validates :description, presence: true
    validates :skills, presence: true

    belongs_to  :user
    belongs_to  :category
    belongs_to  :state
    has_many    :hires
    has_many    :chats

    accepts_nested_attributes_for :user, :allow_destroy => true
    accepts_nested_attributes_for :category, :allow_destroy => true
    accepts_nested_attributes_for :state, :allow_destroy => true
    accepts_nested_attributes_for :hires, :allow_destroy => true
    accepts_nested_attributes_for :chats, :allow_destroy => true


end
