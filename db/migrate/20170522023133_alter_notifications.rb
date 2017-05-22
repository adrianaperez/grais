class AlterNotifications < ActiveRecord::Migration[5.0]
  def up
    rename_column("notifications", "commitment_name", "commitment_desc")
    add_column("notifications", "noti_user_id", :integer)
    rename_column("notifications", "type", "noti_type")
    
  end

  def down
    rename_column("notifications", "commitment_desc", "commitment_name")
    remove_column("notifications", "noti_user_id")
    rename_column("notifications", "noti_type", "type")
    
  end
end
