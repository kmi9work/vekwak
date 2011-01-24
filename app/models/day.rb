class Day < ActiveRecord::Base
  belongs_to :student
  has_many :comments#, :dependent => :delete_all
  has_many :events#, :dependent => :delete_all
  def date
    "#{self[:day]}_#{self[:month]}_#{self[:year]}"
  end
  def to_s
    "#{self[:day]}.#{self[:month]}.#{self[:year]}"
  end
end
