class Todo < ActiveRecord::Base
  attr_accessible :title, :event_id
  belongs_to :event
  
  validates_length_of :title, :maximum => 100
end
