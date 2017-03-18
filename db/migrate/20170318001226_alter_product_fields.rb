class AlterProductFields < ActiveRecord::Migration[5.0]
  def up
    add_belongs_to :products, :team, index: true, foreign_key: true
    change_column :products, :name, :string, limit: 80
    add_column :products, :logo, :string, limit: 120 
  end

  def down
    remove_belongs_to :products, :team, index: true, foreign_key: true
    change_column :products, :name, :string, limit: 255
    remove_column :products, :logo, :string, limit: 120
end
