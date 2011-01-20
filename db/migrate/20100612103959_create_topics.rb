class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :student_id
      t.text :content
      t.integer :rating
      t.string :title
      t.text :annotation, :limit => 256
      t.integer :section_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end