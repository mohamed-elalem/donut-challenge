class ApplicationController < ActionController::API
  before_action :set_current_user

  protected

  def slack_client
    @slack_client ||= client = Slack::Web::Client.new
  end

  private

  def set_current_user
    @current_user = User.find_or_import_by_slack_id(params[:user_id])
  end
end
