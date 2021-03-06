class Task < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :assignee, class_name: 'User'

  validates :content, presence: true
end
