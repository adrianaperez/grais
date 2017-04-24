class CreateCommitmentPrototypes < ActiveRecord::Migration[5.0]
  def up
    create_table :commitment_prototypes do |t|
      t.string :description
      t.date :deadline
      t.belongs_to :prototype, index: true
      t.timestamps
    end
  end

  def down
  	#remove_table("commitment_prototypes")
    drop_table :commitment_prototypes
  end
end
