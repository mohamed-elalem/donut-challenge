class Slack::CreateTask
  include Slack::Chainable


  def handle(params)
    puts "Inside create task"
    next_handler.handle params
  end
end