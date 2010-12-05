class CreateHeadmanAuls < ActiveRecord::Migration
  def self.up
    create_table :headman_auls do |t|
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :headman_auls
  end
end
