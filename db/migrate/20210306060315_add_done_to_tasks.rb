class AddDoneToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :done, :boolean, default: false
  end
end
