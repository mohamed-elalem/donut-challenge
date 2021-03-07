module Slack::Chainable
  attr_reader :next_handler

  def set_next(chainable)
    @next_handler = chainable
  end

  def handle(params)
    raise 'not implemented'
  end
end