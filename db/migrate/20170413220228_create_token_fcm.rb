class CreateTokenFcm < ActiveRecord::Migration[5.0]
  def up
    create_table :fcm_tokens do |t|
    	t.string('token', :limit => 300)
	    t.belongs_to :user, index: true
	    t.timestamps
    end
  end

  def down
      drop_table :fcm_tokens
  end
end
