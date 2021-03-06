class AddReporterIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :reporter_id, :integer
  end

  add_index :tasks, :reporter_id
end
