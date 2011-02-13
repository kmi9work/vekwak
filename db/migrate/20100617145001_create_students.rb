class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table "students", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :group,                     :string, :limit => 40
      t.column :last_visit,                :datetime      
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.integer :rating,                   :default => 0
      t.string :second_name, :limit => 100
      t.string :last_name, :limit => 100
      t.boolean :admin, :default => false
      t.boolean :headman, :default => false
    end
    add_index :students, :login, :unique => true
  end

  def self.down
    drop_table "students"
  end
end
