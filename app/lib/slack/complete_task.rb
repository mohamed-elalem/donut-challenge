class Slack::CompleteTask
  include Slack::Chainable


  def handle(params)
    puts "Inside complete task"
    next_handler.handle params
  end
end