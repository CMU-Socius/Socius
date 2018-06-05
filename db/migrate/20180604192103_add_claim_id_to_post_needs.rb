class AddClaimIdToPostNeeds < ActiveRecord::Migration
  def change
    add_column :post_needs, :claim_id, :integer
  end
end
