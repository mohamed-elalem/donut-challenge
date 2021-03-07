class TasksController < ApplicationController
  include TaskParser
  include ActionView::Helpers::DateHelper

  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
    @tasks = Task.remaining.includes(:reporter)
    
    message = I18n.t('slack.tasks.empty.remaining')
    if @tasks.any?
      tasks_formatted_list = @tasks.map do |task|
        I18n.t(
          'slack.assignee.single_remaining_task',
          task_id: task.id,
          task_content: task.content,
          task_reporter_name: task.reporter.name,
          task_created_at: time_ago_in_words(task.created_at)
          )
      end.join("\n")

      message = I18n.t('slack.assignee.remaining_tasks', tasks_list: tasks_formatted_list)
    end

    slack_client.chat_postMessage(
      channel: @current_user.formatted_slack_handle,
      text: message
    )

    head :ok
  end

  def list_completed_tasks
    @tasks = Task.completed.includes(:reporter)
    
    message = I18n.t('slack.tasks.empty.completed')

    if @tasks.any?
      tasks_formatted_list = @tasks.map do |task|
        I18n.t(
          'slack.assignee.single_completed_task',
          task_id: task.id,
          task_content: task.content,
          task_reporter_name: task.reporter.name,
          task_updated_at: time_ago_in_words(task.updated_at)
          )
      end.join("\n")

      message = I18n.t('slack.assignee.completed_tasks', tasks_list: tasks_formatted_list)
    end
    
    
    slack_client.chat_postMessage(
      channel: @current_user.formatted_slack_handle,
      text: message
    )

    head :ok
  end

  def mark_as_completed
    task = Task.find_by(assignee_id: @current_user.id, id: params[:text], done: false)
    
    if task.present?
      task.mark_as_completed!
  
      slack_client.chat_postMessage(
        channel: @current_user.formatted_slack_handle,
        text: I18n.t('slack.assignee.task_marked_as_completed', task_id: task.id)
      )

      slack_client.chat_postMessage(
        channel: task.reporter.formatted_slack_handle,
        text: I18n.t('slack.reporter.task_marked_as_completed', task_id: task.id, assignee_name: @current_user.name)
      )
  
      head :ok
    else
      slack_client.chat_postMessage(
        channel: @current_user.formatted_slack_handle,
        text: I18n.t('slack.assignee.task_not_found', task_id: params[:text])
      )

      head :bad_request
    end
  end

  private

  def set_current_user
    @current_user = User.find_by(slack_handle: params[:user_name])
  end
end
