class CreateComments < ActiveRecord::Migration[5.0]
  def up
    create_table :comments do |t|
      t.string :comment_text, limit: 140
      t.belongs_to :post, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
  
  def down
      drop_table :comments
  end
end
