class ApplicationController < ActionController::API
  before_action :set_current_user

  protected

  def slack_client
    @slack_client ||= client = Slack::Web::Client.new
  end

  private

  def set_current_user
    @current_user = User.find_by(slack_handle: params[:user_name])
  end
end
