class CreateCampOrgs < ActiveRecord::Migration
  def change
    create_table :camp_orgs do |t|
      t.integer :camp_id
      t.integer :organization_id
      t.timestamps null: false
    end
  end
end
