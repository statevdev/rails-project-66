class CreateRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :repository_checks do |t|
      t.belongs_to :repository, null: false, foreign_key: true
      t.string :aasm_state
      t.string :commit_id
      t.boolean :passed

      t.timestamps
    end
  end
end
