class AddResponsableToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :responsable, :string
  end

  def self.down
    remove_column :events, :responsable
  end
end
