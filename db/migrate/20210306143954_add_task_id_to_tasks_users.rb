class AddTaskIdToTasksUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks_users, :task_id, :integer
  end

  add_index :tasks_users, :task_id
end
