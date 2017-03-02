class CreateCommitments < ActiveRecord::Migration[5.0]
  def change
    create_table :commitments do |t|
      t.string :description
      t.date :deadline
      t.integer :execution
      t.integer :count
      t.integer :user
      t.integer :course
      t.belongs_to :company, index: true
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
end
