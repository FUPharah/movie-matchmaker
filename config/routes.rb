Rails.application.routes.draw do
  devise_for :users

  get '/movies/:imdb_id', to: 'movies#show_by_imdb_id', as: 'show_by_imdb_id'

  resources :movies, only: %i[index search show create] do
    resources :ratings, only: %i[create destroy]

    member do
      get :add_favorite
      get :add_watchlist
    end
  end

  resources :user_movie_lists, only: %i[new index edit update create destroy] do
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
