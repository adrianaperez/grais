class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 32, null: false
      t.string :lastname, limit: 32, null: false
      t.string :email, limit: 64, unique: true, null: false
      t.string :password_digest, limit: 64, null: false
      t.date :birth_date
      t.string :sex, limit: 32
      t.string :phone, limit: 32
      t.string :country, limit: 32
      t.string :state, limit: 32
      t.string :twitter_account, limit: 32
      t.string :skills
      t.timestamps
    end
  end
end
