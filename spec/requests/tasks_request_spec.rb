require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let!(:reporter) { FactoryBot.create :user }
  let!(:assignee) { FactoryBot.create :user }

  after(:each) do
    allow_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).and_call_original
  end

  context 'creating tasks' do
    it 'should call slack api twice for valid input' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(2).times
  
      post create_task_path, params: {user_id: reporter.slack_id, text: "#{assignee.formatted_slack_handle} [assign task]"}
      expect(response).to be_successful
    end
  
    it 'should call slack api once for invalid input' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(1).times
  
      post create_task_path, params: {user_id: reporter.slack_id}
  
      expect(response).to have_http_status(:bad_request)
    end
  end
  
  context 'listing tasks' do
    let!(:completed_tasks) { FactoryBot.create_list :task, 10, assignee: assignee, done: true }
    let!(:remaining_tasks) { FactoryBot.create_list :task, 10, assignee: assignee }
    
    it 'should call slack api once for listing remaining tasks' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(1).times
  
      post list_remaining_tasks_path, params: {user_id: assignee.slack_id}
  
      expect(response).to be_successful
    end

    it 'should call slack api once for listing completed tasks' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(1).times
  
      post list_completed_tasks_path, params: {user_id: assignee.slack_id}
  
      expect(response).to be_successful
    end
  end
  context 'marking task as complete' do
    let(:remaining_task) { FactoryBot.create :task }

    it 'should call slack api twice and responds with success for valid input' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(2).times
      post mark_as_completed_path, params: {user_id: remaining_task.assignee.slack_id, text: remaining_task.id}
      expect(response).to be_successful
    end

    it 'should call slack api once and responds with success for valid input' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(1).times
      post mark_as_completed_path, params: {user_id: remaining_task.assignee.slack_id, text: Faker::Number.number(digits: 10)}
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'responding with forms' do
    let(:reporter) { FactoryBot.create :user }
    let(:assignee) { FactoryBot.create :user }

    before(:each) do
      FactoryBot.create_list :task, 10, assignee: assignee
    end

    after(:each) do
      allow_any_instance_of(Slack::Web::Client).to receive(:dialog_open).and_call_original
      allow_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).and_call_original
    end

    it 'should call slack api once with dialog to respond with create-task form' do
      expect_any_instance_of(Slack::Web::Client).to receive(:dialog_open).exactly(1).times

      post create_task_form_path, params: { user_id: assignee.slack_id, trigger_id: '1234' }
    end

    it 'should call slack api once with dialog to respond with complete-task form' do
      expect_any_instance_of(Slack::Web::Client).to receive(:dialog_open).exactly(1).times

      post complete_task_form_path, params: { user_id: assignee.slack_id, trigger_id: 'kdfnkfdnf' }
    end

    it 'should call slack api once with message for empty remaining tasks' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).exactly(1).times
      post complete_task_form_path, params: { user_id: reporter.slack_id, trigger_id: 'dfknfdknfkndf' }
    end
  end
end
