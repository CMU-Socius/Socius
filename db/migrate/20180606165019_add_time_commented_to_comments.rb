class AddTimeCommentedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :time_commented, :datetime
  end
end
