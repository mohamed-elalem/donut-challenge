require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validations' do
    let(:reporter) { FactoryBot.create :user }
    let(:assignee) { FactoryBot.create :user }

    it 'should not save invalid task' do
      task = Task.new

      task.save

      expect(task.persisted?).to be_falsy
      expect(task.errors).to have_key :reporter
      expect(task.errors).to have_key :assignee
      expect(task.errors).to have_key :content
    end

    it 'should save valid input' do
      task = FactoryBot.build :task

      task.save
      expect(task.persisted?).to be_truthy
    end
  end
end
