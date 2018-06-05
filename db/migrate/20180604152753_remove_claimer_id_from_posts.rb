class RemoveClaimerIdFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :claimer_id, :integer
  end
end
