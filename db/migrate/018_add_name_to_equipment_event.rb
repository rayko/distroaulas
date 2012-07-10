class AddNameToEquipmentEvent < ActiveRecord::Migration
  def self.up
    add_column :equipment_events, :name, :string
  end

  def self.down
    remove_column :equipment_events, :name
  end
end
