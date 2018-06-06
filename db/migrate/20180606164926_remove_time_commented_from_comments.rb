class RemoveTimeCommentedFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :time_commented, :date
  end
end
