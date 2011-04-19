class CreateHusers < ActiveRecord::Migration
  def self.up
    create_table :husers do |t|
      t.string :login
      t.string :password
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :husers
  end
end
