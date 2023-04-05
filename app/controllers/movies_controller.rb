class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def create
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
