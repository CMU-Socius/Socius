class AddDatesToPost < ActiveRecord::Migration
  def change
    add_column :posts, :date_claimed, :date
    add_column :posts, :date_cancelled, :date
  end
end
