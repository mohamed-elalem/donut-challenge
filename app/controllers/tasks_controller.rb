class TasksController < ApplicationController
  include TaskParser
  include ActionView::Helpers::DateHelper

  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
    @tasks = Task.remaining.includes(:reporter, :assignee).where(assignee: { id: @current_user.id})
    message = JSON.parse(ActionController::Base.render('tasks/assignee/remaining-tasks', locals: { tasks: @tasks }))

    slack_client.chat_postMessage(
      channel: @current_user.formatted_slack_handle,
      blocks: message
    )

    head :ok
  end

  def list_completed_tasks
    @tasks = Task.completed.includes(:reporter, :assignee).where(assignee: { id: @current_user.id})
    
    message = JSON.parse(ActionController::Base.render('tasks/assignee/completed-tasks', locals: { tasks: @tasks }))

    slack_client.chat_postMessage(
      channel: @current_user.formatted_slack_handle,
      blocks: message
    )

    head :ok


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


  def create_task_form
    dialog = JSON.parse(ActionController::Base.render('tasks/task-form'))
    slack_client.dialog_open(
      trigger_id: params[:trigger_id],
      dialog: dialog
    )
  end

  def complete_task_form
    tasks = @current_user.remaining_tasks
    if tasks.any?
      dialog = JSON.parse(ActionController::Base.render('tasks/complete-task-form', locals: { tasks: tasks }))

      slack_client.dialog_open(
        trigger_id: params[:trigger_id],
        dialog: dialog
      )
    else
      slack_client.chat_postMessage(
        channel: @current_user.slack_id,
        text: I18n.t('slack.assignee.empty_remaining_tasks')
      )
    end
  end
end
