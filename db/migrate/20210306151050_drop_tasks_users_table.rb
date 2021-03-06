class DropTasksUsersTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :tasks_users
  end
end
