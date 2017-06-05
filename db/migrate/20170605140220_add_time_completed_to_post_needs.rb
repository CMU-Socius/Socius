class AddTimeCompletedToPostNeeds < ActiveRecord::Migration
  def change
    add_column :post_needs, :time_completed, :datetime
  end
end
