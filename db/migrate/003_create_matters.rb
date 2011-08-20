class CreateMatters < ActiveRecord::Migration
  def self.up
    create_table :matters do |t|
      t.string :name
      t.string :short_name
      t.integer :career_id
      t.integer :year
      t.timestamps
    end
  end

  def self.down
    drop_table :matters
  end
end
