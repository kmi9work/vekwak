class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.integer :day
      t.integer :month
      t.integer :year
      t.integer :student_id
      t.timestamps
    end
  end

  def self.down
    drop_table :days
  end
end
