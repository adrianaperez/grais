class AlterCommitments < ActiveRecord::Migration[5.0]
  def up
    remove_column("commitments", "course")
    remove_column("commitments", "company_id")
  end

  def down
  	add_column("commitments", "company_id", :integer)
  	add_column("commitments", "course", :integer)
  end
end
