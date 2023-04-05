Rails.application.routes.draw do
  devise_for :users

  resources :movies, only: %i[index show create] do
    resources :ratings, only: %i[create destroy]
  end

  resources :user_movie_lists, only: %i[new index edit create destroy] do
    collection do
      get :favorite
      get :watchlist
    end
  end
  resources :genres, only: %i[index show]
  resources :mood_tags, only: %i[index show]

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  root to: 'pages#home'
end
