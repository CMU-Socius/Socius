class CreateCamps < ActiveRecord::Migration
  def change
    create_table :camps do |t|
      t.float :latitude, array: true
      t.float :longitude, array: true
      t.string :street_1
      t.string :street_2
      t.string :zip
      t.string :city
      t.string :state
      t.string :name
      t.timestamps null: false
    end
  end
end
