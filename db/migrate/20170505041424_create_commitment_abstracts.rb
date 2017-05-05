class CreateCommitmentAbstracts < ActiveRecord::Migration[5.0]
  def up
    create_table :commitment_abstracts do |t|
	    t.string :abstract, limit: 300
	    t.belongs_to :commitment, index: true
      t.timestamps
    end
  end

  def down
  	drop_table :commitment_abstracts
  end
end

