class AddCompletedToPostNeeds < ActiveRecord::Migration
  def change
    add_column :post_needs, :completed, :boolean
  end
end
