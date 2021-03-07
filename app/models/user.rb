class User < ApplicationRecord
  has_many :reported_tasks, class_name: 'Task', foreign_key: :reporter_id
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id

  def formatted_slack_handle
    '@' + slack_handle
  end

  def remaining_tasks
    self.assigned_tasks.where(done: false)
  end
end
