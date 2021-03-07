Rails.application.routes.draw do
  # For details on the DSL available withi
  scope :tasks do
    post :create_task, to: 'tasks#create_task'
    post :list_remaining_tasks, to: 'tasks#list_remaining_tasks'
    post :list_completed_tasks, to: 'tasks#list_completed_tasks'
    post :mark_as_completed, to: 'tasks#mark_as_completed'
    post :create_task_form, to: 'tasks#create_task_form'
    post :complete_task_form, to: 'tasks#complete_task_form'
  end

  scope :slack, as: :slack do
    post :callback, to: 'slack#callback'
  end
end
