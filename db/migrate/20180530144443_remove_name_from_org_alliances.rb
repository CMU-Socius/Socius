class RemoveNameFromOrgAlliances < ActiveRecord::Migration
  def change
    remove_column :org_alliances, :name, :string
  end
end
