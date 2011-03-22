class AddPrevVisitToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :prev_visit, :datetime
  end

  def self.down
    remove_column :students, :prev_visit
  end
end
