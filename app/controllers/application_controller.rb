class ApplicationController < ActionController::API

  protected
    def slack_client
      @slack_client ||= client = Slack::Web::Client.new
    end
end
