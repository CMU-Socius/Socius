class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :poster_id
      t.integer :claimer_id
      t.float :latitude
      t.float :longitude
      t.integer :number_people
      t.string :street_1
      t.string :street_2
      t.string :zip
      t.string :city
      t.string :state
      t.date :date_posted
      t.date :date_completed

      t.timestamps null: false
    end
  end
end
