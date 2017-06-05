class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :role
      t.integer :organization_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
