class CommentRatingStudent < ActiveRecord::Base
  belongs_to :comment
  belongs_to :student
end
