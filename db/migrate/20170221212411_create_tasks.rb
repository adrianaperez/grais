class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :description
      t.date :deadline
      t.integer :execution
      t.integer :weight
      t.belongs_to :commitment, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
