require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let!(:reporter) { FactoryBot.create :user }
  let!(:assignee) { FactoryBot.create :user }

  it 'should call slack api twice for valid input' do
    expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(2).times

    post create_task_path, params: {user_name: reporter.slack_handle, text: "#{assignee.formatted_slack_handle} [assign task]"}
    expect(response).to be_successful
  end

  it 'should call slack api once for invalid input' do
    expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(1).times

    post create_task_path, params: {user_name: reporter.slack_handle}

    expect(response).to have_http_status(:bad_request)
  end
end
