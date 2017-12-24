Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :roles
    resources :school_classes
  end

  resources :students do
    #resources :past_education_records, except: [:index, :show]
    resources :point_of_contacts, except: [:index, :show]
    resources :remarks, except: [:index, :show]
  end
  resources :internship_supervisors
  resources :medical_conditions
  resources :disabilities
	resources :internship_companies
  resources :attendances

  root to: 'pages#index'
  get 'pages/index'

  devise_for :users, skip: [:registrations]
  as :user do
    get 'profile' => 'devise/registrations#edit', :as => 'edit_profile'
    patch 'profile' => 'devise/registrations#update', :as => 'profile'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
