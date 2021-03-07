class SlackController < ApplicationController
  def callback
    chain.handle JSON.parse(params[:payload]).with_indifferent_access
  end

  def chain
    @chain ||= Slack::Chain.new.with(Slack::CreateTask).with(Slack::CompleteTask).end
  end
end
