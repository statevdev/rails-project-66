class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :nickname
      t.string :token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :nickname, unique: true
    add_index :users, :token, unique: true
  end
end
