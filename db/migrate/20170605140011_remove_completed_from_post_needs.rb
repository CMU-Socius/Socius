class RemoveCompletedFromPostNeeds < ActiveRecord::Migration
  def change
    remove_column :post_needs, :completed, :boolean
  end
end
