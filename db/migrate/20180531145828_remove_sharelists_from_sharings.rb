class RemoveSharelistsFromSharings < ActiveRecord::Migration
  def change
    remove_column :sharings, :sharelists, :string
  end
end
