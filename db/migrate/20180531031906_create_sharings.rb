class CreateSharings < ActiveRecord::Migration
  def change
    create_table :sharings do |t|
      t.integer :post_id
      t.integer :alliance_id
      t.timestamps null: false
    end
  end
end
