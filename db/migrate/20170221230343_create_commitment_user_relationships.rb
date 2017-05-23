class CreateCommitmentUserRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :commitment_user_relationships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :commitment, index: true
      t.string :exonerated
      t.timestamps
    end
  end
end
