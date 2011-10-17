class AddExtraFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :full_name, :string
    add_column :users, :role, :string
  end

  def self.down
    remove_column :users, :username
    remove_column :users, :full_name
    remove_column :users, :role
  end
end
