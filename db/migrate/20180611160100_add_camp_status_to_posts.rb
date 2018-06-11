class AddCampStatusToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :camp_status, :string, default: "requests"
  end
end
