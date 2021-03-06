Rails.application.routes.draw do
  # For details on the DSL available withi
  scope :tasks do
    post :create_task, to: 'tasks#create_task'
    post :list_tasks, to: 'tasks#list_tasks'
  end
end
