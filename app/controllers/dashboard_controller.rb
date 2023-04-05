class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_movie_lists = current_user.user_movie_lists
    @user_favorite_movies = current_user.movies.where("user_movie_lists.watchlist = ?", false)
    @user_watched_movies = current_user.movies.where("user_movie_lists.watchlist = ?", true)
  end

  def favorite
    @user_movie_list = UserMovieList.create(
      user: current_user,
      movie: Movie.find(params[:movie_id]),
      favorite: true, watchlist: false
    )
    if @user_movie_list.persisted?
      redirect_to dashboard_path
    else
      render 'dashboard/index', status: :unprocessable_entity
    end
  end
end
