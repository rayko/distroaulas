class CreateSpaces < ActiveRecord::Migration
  def self.up
    create_table :spaces do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :capacity
      t.integer :spacetype_id
      t.timestamps
    end
  end

  def self.down
    drop_table :spaces
  end
end
