class FixAttrInEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :responsable, :responsible
  end

  def self.down
    rename_column :events, :responsible, :responsable
  end
end
