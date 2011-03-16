class CreateNovelties < ActiveRecord::Migration
  def self.up
    create_table :novelties do |t|
      t.integer :student_id
      t.string :title
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :novelties
  end
end
