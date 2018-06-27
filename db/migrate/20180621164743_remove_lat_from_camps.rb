class RemoveLatFromCamps < ActiveRecord::Migration
  def change
    remove_column :camps, :lat, :float
    remove_column :camps, :long, :float
    remove_column :camps, :latitude, :float
    remove_column :camps, :longitude, :float
  end
end
