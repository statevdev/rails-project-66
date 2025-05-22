class ChangeRepositoryChecksAasmState < ActiveRecord::Migration[7.1]
  def change
    change_column :repository_checks, :aasm_state, :string, null: false, default: 'created'
  end
end
