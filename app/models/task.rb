class Task < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :assignee, class_name: 'User'

  validates :content, presence: true
  validate :reporter_assignee_different

  scope :completed, -> { where(done: true) }
  scope :remaining, -> { where(done: false) }

  def mark_as_completed!
    update!(done: true)
  end

  def created_at_formatted
    created_at.strftime("%A, %B %d %Y at %I:%M %p (#{Time.zone.name} %:z)")
  end

  def updated_at_formatted
    updated_at.strftime("%A, %B %d %Y at %I:%M %p (#{Time.zone.name} %:z)")
  end

  private

  def reporter_assignee_different
    if reporter.present? && assignee.present? &&
        reporter.persisted? && assignee.persisted? &&
        reporter.id == assignee.id

      errors.add(:base, I18n.t('models.task.errors.reporter_assignee_different'))
    end
  end
end
