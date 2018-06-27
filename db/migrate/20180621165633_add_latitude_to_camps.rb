class AddLatitudeToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :latitude, :float
    remove_column :camps, :lantitude, :float
  end
end
