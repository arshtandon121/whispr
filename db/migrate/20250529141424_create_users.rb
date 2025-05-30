class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false
      t.string :remember_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :remember_token
  end
end 