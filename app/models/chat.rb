class Chat < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
  belongs_to :hire

  accepts_nested_attributes_for :user, :allow_destroy => true
  accepts_nested_attributes_for :job, :allow_destroy => true
  accepts_nested_attributes_for :hire, :allow_destroy => true
end
