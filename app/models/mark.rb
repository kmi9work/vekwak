class Mark < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :mark
  validates_numericality_of :mark, :greater_or_equal_than => 0, :less_or_equal_than => 100, 
                            :message => 'Оценка должна принадлежать отрезку [0,100]'
  
  belongs_to :student
end
