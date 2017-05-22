class CreatePosts < ActiveRecord::Migration[5.0]
  def up
    create_table :posts do |t|
      t.string :post_text, limit: 140
      t.belongs_to :course, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
  
  def down
      drop_table :posts
  end
end
