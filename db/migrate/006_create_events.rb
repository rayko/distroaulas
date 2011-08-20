class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.integer :matter_id
      t.integer :space_id
      t.datetime :dtstart
      t.datetime :dtend
      t.text :exdate
      t.text :rdate
      t.boolean :recurrent
      t.string :freq
      t.integer :calendar_id
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
