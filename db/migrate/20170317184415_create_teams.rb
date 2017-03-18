class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name, limit: 80, null: false
      t.string :description, limit: 120
      t.string :initials, limit: 8
      t.string :logo, limit: 200
      t.belongs_to :course, index: true
      t.timestamps
    end
  end
end
