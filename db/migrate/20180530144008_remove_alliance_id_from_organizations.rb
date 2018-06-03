class RemoveAllianceIdFromOrganizations < ActiveRecord::Migration
  def change
    remove_column :organizations, :alliance_id, :integer
  end
end
