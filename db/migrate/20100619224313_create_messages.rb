class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :content
      t.integer :student_id
      t.integer :student_from_id
      t.boolean :new, :default => 1
      
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
