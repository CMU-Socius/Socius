class AddEmailNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_notification, :boolean,default: true
  end
end
