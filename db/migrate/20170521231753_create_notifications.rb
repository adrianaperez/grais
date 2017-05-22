class CreateNotifications < ActiveRecord::Migration[5.0]
  def up
    create_table :notifications do |t|
	    t.string :type, limit: 80
	    t.boolean :viewed
	    t.boolean :accepted

	    t.integer :course_id
	    t.string :course_name, limit: 100
	    t.integer :user_id
	    t.string :user_name, limit: 120
	    t.integer :team_id
	    t.string :team_name, limit: 100
	    t.integer :commitment_id
	    t.string :commitment_name
	    t.integer :task_id
	    t.string :task_desc
	    t.integer :product_id

			t.belongs_to :user, index: true
      t.timestamps
    end
  end

  def down
  	drop_table :notifications
  end
end
