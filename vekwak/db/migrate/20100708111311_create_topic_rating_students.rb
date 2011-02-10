class CreateTopicRatingStudents < ActiveRecord::Migration
  def self.up
    create_table :topic_rating_students do |t|
      t.integer :topic_id
      t.integer :student_id
      t.integer :mark
      t.timestamps
    end
  end

  def self.down
    drop_table :topic_rating_students
  end
end
