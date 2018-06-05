class CreatePostClaims < ActiveRecord::Migration
  def change
    create_table :post_claims do |t|
      t.integer :post_id
      t.integer :claimer_id
      t.timestamps null: false
    end
  end
end
