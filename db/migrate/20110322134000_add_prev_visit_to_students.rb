class AddPrevVisitToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :prev_visit, :datetime, :default => Time.now
  end

  def self.down
    remove_column :students, :prev_visit
  end
end
