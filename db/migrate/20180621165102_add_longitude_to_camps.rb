class AddLongitudeToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :longitude, :float
    add_column :camps, :lantitude, :float
    add_column :camps, :lat, :float, array: true
    add_column :camps, :long, :float, array: true
  end
end
