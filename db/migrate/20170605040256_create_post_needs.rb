class CreatePostNeeds < ActiveRecord::Migration
  def change
    create_table :post_needs do |t|
      t.integer :need_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
