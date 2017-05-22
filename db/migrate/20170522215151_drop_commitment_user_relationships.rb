class DropCommitmentUserRelationships < ActiveRecord::Migration[5.0]
  def up
    drop_table("commitment_user_relationships")
  end

  def down
    create_table(:commitment_user_relationships)
  end
end
