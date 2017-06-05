class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
