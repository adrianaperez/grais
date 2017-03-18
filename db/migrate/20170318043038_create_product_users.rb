class CreateProductUsers < ActiveRecord::Migration[5.0]
  def up
    create_table :product_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
 
  def down
    drop_table :product_users
  end
end
