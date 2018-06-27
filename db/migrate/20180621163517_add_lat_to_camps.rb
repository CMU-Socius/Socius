class AddLatToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :lat, :float
    add_column :camps, :long, :float
  end
end
