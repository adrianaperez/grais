class AddForeignKeyToProductAndCommitment < ActiveRecord::Migration[5.0]
  def up
    add_belongs_to :products, :prototype, index: true, foreign_key: true
    add_belongs_to :commitments, :commitment_prototype, index: true, foreign_key: true
  end

  def down
    remove_belongs_to :products, :prototype, index: true, foreign_key: true
    remove_belongs_to :commitments, :commitment_prototype, index: true, foreign_key: true
  end
end
