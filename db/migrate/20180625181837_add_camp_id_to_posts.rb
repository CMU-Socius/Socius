class AddCampIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :camp_id, :integer
  end
end
