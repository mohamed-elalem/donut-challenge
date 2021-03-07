class Task < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :assignee, class_name: 'User'

  validates :content, presence: true

  scope :completed, -> { where(done: true) }
  scope :remaining, -> { where(done: false) }

  def mark_as_completed!
    update!(done: true)
  end
end
