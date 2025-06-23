Rails.application.routes.draw do
  namespace :admin do
  resources :users, only: [ :new, :create ]
end
  get "admin_dashboard/index"
  get "admin_dashboard/users"
  get "admin_dashboard/update_user_role"
  get "doctors/index"
  resources :patients
  devise_for :users, skip: [ :registrations ]
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
