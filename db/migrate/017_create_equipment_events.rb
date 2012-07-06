class CreateEquipmentEvents < ActiveRecord::Migration
  def self.up
    create_table :equipment_events do |t|
      t.datetime :dtstart
      t.datetime :dtend
      t.integer :event_id
      t.integer :equipment_id
      t.integer :space_id

      t.timestamps
    end
  end

  def self.down
    drop_table :equipment_events
  end
end
