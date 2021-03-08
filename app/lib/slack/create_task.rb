class Slack::CreateTask
  include Slack::Chainable


  def handle(params)
    if params['callback_id'] == 'create-task'
      reporter = User.find_or_import_by_slack_id(params['user']['id'])
      assignee = User.find_or_import_by_slack_id(params['submission']['task_assignee'])
      content = params['submission']['content']
    
      create_task(reporter, assignee, content)
    end

    next_handler.handle params
  end

  private

  def create_task(reporter, assignee, content)
    task = Task.new(content: content, reporter: reporter, assignee: assignee)
    client = Slack::Client.instance

    if task.save
      client.chat_postMessage(
        channel: reporter.formatted_slack_handle,
        blocks: JSON.parse(ActionController::Base.render('tasks/reporter/task-assigned', locals: { task: task }))
      )

      client.chat_postMessage(
        channel: assignee.formatted_slack_handle,
        blocks: JSON.parse(ActionController::Base.render('tasks/assignee/task-assigned', locals: { task: task }))
      )
    else
      client.chat_postMessage(
        channel: reporter.formatted_slack_handle,
        blocks: JSON.parse(ActionController::Base.render('shared/errors', locals: { resource: task }))
      )
    end
  end
end
