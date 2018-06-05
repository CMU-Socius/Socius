class RemoveDateClaimedFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :date_claimed, :date
  end
end
