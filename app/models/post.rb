class Post < ActiveRecord::Base
  belongs_to :student
  belongs_to :section
  has_many :comments, :dependent => :delete_all
  has_one :voting
  has_many :post_rating_students, :dependent => :delete_all
end