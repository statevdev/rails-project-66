class AddIndexToRepositoriesFullName < ActiveRecord::Migration[7.1]
  def change
    add_index :repositories, :full_name, unique: true
  end
end
