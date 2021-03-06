class User < ApplicationRecord
  has_many :reported_tasks, class_name: 'Task', foreign_key: :reporter_id
  has_one :assigned_task, class_name: 'Task', foreign_key: :assignee_id

  def formatted_slack_handle
    '@' + slack_handle
  end
end
