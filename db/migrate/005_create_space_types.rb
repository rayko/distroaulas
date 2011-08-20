class CreateSpaceTypes < ActiveRecord::Migration
  def self.up
    create_table :space_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :space_types
  end
end
