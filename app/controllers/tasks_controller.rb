class TasksController < ApplicationController
  include TaskParser
  before_action :set_current_user

  def create_task
    task_assignee = User.find_by(slack_handle: extract_task_assignee(params[:text]))
    task_content = extract_task_content(params[:text])
    task = Task.new(content: task_content)
    task.reporter = @current_user
    task.assignee = task_assignee

    if task.save
      slack_client.chat_postMessage(
        channel: @current_user.formatted_slack_handle,
        text: I18n.t('slack.reporter.task_assigned', content: task.content, assignee_name: task_assignee.name)
      )

      slack_client.chat_postMessage(
        channel: task_assignee.formatted_slack_handle,
        text: I18n.t('slack.assignee.task_assigned', content: task.content, reporter_name: @current_user.name)
      )

      head :ok
    else
      slack_client.chat_postMessage(
        channel: @current_user.formatted_slack_handle,
        text: I18n.t('slack.reporter.task_assigned_errors', errors: task.errors.full_messages.map { |msg| "*#{msg}*" }.join(', '))
      )

      head :bad_request
    end
  end

  def list_remaining_tasks
    
  end

  def list_completed_tasks

  end

  private

  def set_current_user
    @current_user = User.find_by(slack_handle: params[:user_name])
  end
end
