class CreateCourseUsers < ActiveRecord::Migration[5.0]
  def up
    	create_table :course_users do |t|
  	 		t.integer "user_id"
      	t.integer "course_id"
      	t.string "rol"
        	
      	t.timestamps
    	end

    	add_index("course_users", ['user_id', 'course_id'])
  	end

  	def down
    	drop_table :course_users
  	end
 end
