class ChangePassedDefaultInCheck < ActiveRecord::Migration[7.1]
  def change
    change_column_default :repository_checks, :passed, false
  end
end
