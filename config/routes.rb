Rails.application.routes.draw do
  get 'internship_supervisors/index'

  get 'internship_supervisors/new'

  get 'internship_supervisors/create'

  get 'internship_supervisors/edit'

  get 'internship_supervisors/update'

  get 'internship_supervisors/destroy'

  namespace :admin do
    resources :users
    resources :roles
    resources :school_classes
  end
  resources :internship_supervisors

  root to: 'pages#index'
  get 'pages/index'

  devise_for :users, skip: [:registrations]
  as :user do
    get 'profile' => 'devise/registrations#edit', :as => 'edit_profile'
    patch 'profile' => 'devise/registrations#update', :as => 'profile'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
