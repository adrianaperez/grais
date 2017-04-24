class AlterPrototypes < ActiveRecord::Migration[5.0]
  def up
    add_column("prototypes", "initials", :string, limit: 8)
  end

  def down
  	remove_column("prototypes", "initials", :string, limit: 8)
  end
end
