class Comment < ActiveRecord::Base
  belongs_to :topic
  
  belongs_to :student
  
  belongs_to :comment
    
  has_many :comments, :dependent => :delete_all
end
