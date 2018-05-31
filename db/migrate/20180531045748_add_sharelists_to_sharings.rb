class AddSharelistsToSharings < ActiveRecord::Migration
  def change
    add_column :sharings, :sharelists, :string
  end
end
