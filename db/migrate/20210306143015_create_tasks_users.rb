class CreateTasksUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks_users do |t|
      t.integer :reporter_id
      t.integer :assignee_id
      t.timestamps
    end

    add_index :tasks_users, :reporter_id
    add_index :tasks_users, :assignee_id
  end
end
