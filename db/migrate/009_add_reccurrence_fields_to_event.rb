class AddReccurrenceFieldsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :interval, :integer
    add_column :events, :until_date, :datetime
    add_column :events, :byday, :string
    add_column :events, :count, :integer
  end

  def self.down
    remove_column :events, :interval, :integer
    remove_column :events, :until_date, :datetime
    remove_column :events, :byday, :string
    remove_column :events, :count, :integer
  end
end
