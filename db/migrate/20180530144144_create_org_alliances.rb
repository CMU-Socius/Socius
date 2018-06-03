class CreateOrgAlliances < ActiveRecord::Migration
  def change
    create_table :org_alliances do |t|
      t.integer :organization_id
      t.integer :alliance_id
      t.string :name
      t.timestamps null: false
    end
  end
end
