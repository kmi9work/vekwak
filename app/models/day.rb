class Day < ActiveRecord::Base
  belongs_to :student
  has_many :comments
  has_many :events
  def date
    "#{self[:day]}_#{self[:month]}_#{self[:year]}"
  end
end
