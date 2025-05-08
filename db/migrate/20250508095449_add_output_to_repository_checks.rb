class AddOutputToRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    add_column :repository_checks, :output, :json, default: {}
  end
end
