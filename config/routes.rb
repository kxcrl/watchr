Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new', as: :signup

  post 'login', to: 'sessions#create'
  post 'authenticate', to: 'auth#login'

  resources :users, only: [:new, :create]
  resources :movies, only: [:index, :show]
  resources :favorites, only: [:index, :create, :destroy] do
    collection do
      post :toggle
    end
  end

  post 'favorites/:movie_id', to: 'favorites#create'

  root "pages#landing"
end
