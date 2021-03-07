class Slack::CompleteTask
  include Slack::Chainable


  def handle(params)
    if params['callback_id'] == 'complete-task'
      task = Task.includes(:assignee).find_by(id: params['submission']['task'], assignee: { slack_id: params['user']['id'] })
      client = Slack::Client.instance

      task.mark_as_completed! if task.present?

      client.chat_postMessage(
        channel: task.reporter.formatted_slack_handle,
        blocks: JSON.parse(ActionController::Base.render('tasks/reporter/task-completed', locals: { task: task }))
      )

      client.chat_postMessage(
        channel: task.assignee.formatted_slack_handle,
        blocks: JSON.parse(ActionController::Base.render('tasks/assignee/task-completed', locals: { task: task }))
      )
    end
    next_handler.handle params
  end
end