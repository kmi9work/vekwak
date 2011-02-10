class Message < ActiveRecord::Base
  validates_presence_of :student_id
  belongs_to :student
  belongs_to :student_from, :class_name => 'Student'
end
