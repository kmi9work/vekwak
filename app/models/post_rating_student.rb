class PostRatingStudent < ActiveRecord::Base
  belongs_to :post
  belongs_to :student
end
