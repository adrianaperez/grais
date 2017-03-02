class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name, limit: 32, null: false
      t.text :description
      t.string :registration
      t.string :strict_isa
      t.string :evaluation
      t.timestamps
    end
  end
end
