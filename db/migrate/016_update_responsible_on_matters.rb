class UpdateResponsibleOnMatters < ActiveRecord::Migration
  def self.up
    rename_column :matters, :responsable, :responsible
  end

  def self.down
    rename_column :matters, :responsible, :responsable
  end
end
