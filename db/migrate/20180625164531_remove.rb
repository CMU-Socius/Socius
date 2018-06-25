class Remove < ActiveRecord::Migration
  def change
    remove_column :camps, :lat, :float, array: true
    remove_column :camps, :long, :float, array: true
    add_column :camps, :lat, :string
    add_column :camps, :long, :string
  end
end
