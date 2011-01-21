class CreatePostRatingStudents < ActiveRecord::Migration
  def self.up
    create_table :post_rating_students do |t|
      t.integer :post_id
      t.integer :student_id
      t.integer :mark
      t.timestamps
    end
  end

  def self.down
    drop_table :post_rating_students
  end
end
