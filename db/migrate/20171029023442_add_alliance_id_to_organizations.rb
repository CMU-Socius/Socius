class AddAllianceIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :alliance_id, :integer
  end
end
