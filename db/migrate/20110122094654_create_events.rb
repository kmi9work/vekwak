class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :content
      t.integer :day_id
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
