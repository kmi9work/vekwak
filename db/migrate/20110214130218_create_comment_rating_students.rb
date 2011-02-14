class CreateCommentRatingStudents < ActiveRecord::Migration
  def self.up
    create_table :comment_rating_students do |t|
      t.integer :comment_id
      t.integer :student_id
      t.integer :mark
      t.timestamps
    end
  end

  def self.down
    drop_table :comment_rating_students
  end
end
