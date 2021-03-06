class Post < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 6
  belongs_to :student
  belongs_to :section
  has_many :comments, :dependent => :destroy
  has_one :voting
  has_many :post_rating_students, :dependent => :destroy
  has_many :blinds, :dependent => :destroy
end
