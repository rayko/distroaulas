class AddResponsableToMatter < ActiveRecord::Migration
  def self.up
    add_column :matters, :responsable, :string
  end

  def self.down
    remove_column :matters, :responsable
  end
end
