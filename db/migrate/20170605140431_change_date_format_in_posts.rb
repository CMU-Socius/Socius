class ChangeDateFormatInPosts < ActiveRecord::Migration
  def up
    change_column :posts, :date_posted, :datetime
    change_column :posts, :date_completed, :datetime
  end

  def down
    change_column :posts, :date_completed, :date
    change_column :posts, :date_posted, :datetime
  end
end
