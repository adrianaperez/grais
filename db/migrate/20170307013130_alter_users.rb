class AlterUsers < ActiveRecord::Migration[5.0]
    def up #moving up to a new state
    rename_column("users","name","names")
    change_column("users","names",:string, :limit => 50, :null => false)
    rename_column("users","lastname","lastnames") 
 	  change_column("users","lastnames",:string, :limit => 50, :null => false)
  	change_column("users","password_digest",:string, :limit => 65, :null => false)
  	remove_column("users","birth_date")
  	remove_column("users","sex")
  	add_column("users","initials",:string,:limit => 8,:after => "password_digest")
  	rename_column("users","state","city")
  	change_column("users","phone",:string ,:limit => 32,:after => "city")
    rename_column("users","twitter_account","sn_one")
    change_column("users","sn_one", :string, :limit => 40)
    add_column("users","sn_two",:string, :limit => 40,:after => "sn_one")
    change_column("users","reset_digest",:string,:limit => 65, :after => "skills") 
    change_column("users","reset_sent_at",:datetime,:after => "reset_digest")
    add_column("users","image_user",:string,:limit => 200,:after => "reset_sent_at")

  end

  def down #moving back down to the previous state
    remove_column("users","image_user")
	  change_column("users","reset_sent_at",:datetime,:after => "reset_digest") 
	  change_column("users","reset_digest",:string,:after => "updated_at") 
	  remove_column("users","sn_two") 
	  change_column("users","sn_one", :string, :limit => 32) 
  	change_column("users","phone",:string ,:limit => 32)
  	remove_column("users","initials")  
  	rename_column("users","city","state")  
  	add_column("users","sex", :string,:limit => 32)
  	add_column("users","birth_date", :date ) 
  	change_column("users","password_digest",:string, :limit => 64, :null => false) 
 	  change_column("users","lastnames",:string, :limit => 32, :null => false)
    rename_column("users","lastnames","lastname") 
    change_column("users","names",:string, :limit => 32, :null => false)
    rename_column("users","names","name")

  end
end