Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'static_pages#top'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create]
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :lists, only: %i[index edit update show destroy]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
  resources :cards do
    resources :comments, only: [:create, :update, :destroy, :edit]
  end
  resources :groups do
    delete 'delete_group'
  end
  post "join_or_show_by_invitation" => "groups#join_or_show_by_invitation"
  get 'invitation', to: 'groups#show_by_invitation', as: :group_by_invitation
end
