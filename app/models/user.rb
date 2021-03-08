class User < ApplicationRecord
  has_many :reported_tasks, class_name: 'Task', foreign_key: :reporter_id
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id

  class << self
    def find_or_import_by_slack_id(id)
      user = User.find_or_initialize_by(slack_id: id)

      unless user.persisted?
        user_info = Slack::Client.instance.users_info(user: id)
        user.slack_handle = user_info['user']['name']
        user.name = user_info['user']['real_name']
        user.save
      end

      user
    end
  end

  def formatted_slack_handle
    "@#{slack_handle}"
  end

  def remaining_tasks
    assigned_tasks.where(done: false)
  end
end
