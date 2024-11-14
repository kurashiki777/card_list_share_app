Rails.application.routes.draw do
  devise_for :users, controllers: {
  passwords: 'devise/passwords',
  sessions: 'devise/sessions',
  registrations: 'devise/registrations',
  omniauth_callbacks: 'users/omniauth_callbacks'
}

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  
  root 'static_pages#top'

  resources :lists, only: %i[index edit update show destroy]
  resource :profile, only: %i[show edit update]
  resources :cards do
    resources :comments, only: %i[create update destroy edit]
  end
  resources :groups do
    delete 'delete_group'
  end
  post 'join_or_show_by_invitation' => 'groups#join_or_show_by_invitation'
  get 'invitation', to: 'groups#show_by_invitation', as: :group_by_invitation
end