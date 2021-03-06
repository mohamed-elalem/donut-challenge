module TaskParser
  extend ActiveSupport::Concern

  def extract_task_assignee(content)
    if content.present?
      matched = content[/@[^\s]*/, 0]
      matched[1..] if matched.present?
    end
  end

  def extract_task_content(content)
    content[/(?<=\[).*(?=\])/, 0] if content.present?
  end
end
