class AlterProducts < ActiveRecord::Migration[5.0]
  def up
    add_column("products", "initials", :string, limit: 8)
  end

  def down
  	remove_column("products", "initials", :string, limit: 8)
  end
end
