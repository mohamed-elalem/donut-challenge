class AddAsigneeIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :assignee_id, :integer
  end

  add_index :tasks, :assignee_id
end
