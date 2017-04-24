class CreatePrototypes < ActiveRecord::Migration[5.0]
  def up
    create_table :prototypes do |t|
	    t.string :name, limit: 80
	    t.string :description
	    t.belongs_to :course, index: true
	    t.string :logo, limit: 120
    end
  end
  
  def down
  		#remove_table("prototypes")
      drop_table :prototypes
  end
end
