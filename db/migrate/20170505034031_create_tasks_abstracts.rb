class CreateTasksAbstracts < ActiveRecord::Migration[5.0]
  def up
    create_table :tasks_abstracts do |t|
	    t.string :abstract, limit: 200
	    t.belongs_to :task, index: true
      t.timestamps
    end
  end

  def down
  	drop_table :tasks_abstracts
  end
end
