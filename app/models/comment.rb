class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :student
  belongs_to :comment
  belongs_to :day
  has_many :comments, :dependent => :delete_all
  has_many :comment_rating_students, :dependent => :delete_all
end
