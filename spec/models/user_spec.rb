require 'rails_helper'

RSpec.describe Task, type: :model do
  after(:each) do
    allow(Slack::Client.instance).to receive(:users_info).and_call_original
  end

  it 'should call slack api once if user does not exist' do
    expect(Slack::Client.instance).to receive(:users_info).exactly(1).with(user: 'slack_id').and_return({
      'user' => {
        'name' => 'name',
        'real_name' => 'real_name'
      }
    })

    user = User.find_or_import_by_slack_id('slack_id')
    expect(user.name).to eq('real_name')
    expect(user.slack_handle).to eq('name')
  end

  it 'should call slack api for existing user' do
    expect(Slack::Client.instance).not_to receive(:users_info)

    user = FactoryBot.create :user

    User.find_or_import_by_slack_id(user.slack_id)
  end
end
