class UserMovieListsController < ApplicationController
  before_action :set_user_movie_list, only: [:show, :edit, :update, :destroy]
  before_action :set_movie, only: [:add_favorite]

  def new
    @user_movie_list = UserMovieList.new
  end

  def add_favorite
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

  def edit
    @user_movie_list = UserMovieList.find(params[:id])
  end

  def index
    @user_movie_lists = UserMovieList.all
  end

  def create
    @user_movie_list = UserMovieList.new(user_movie_list_params)
    @user_movie_list.user = current_user
    if @user_movie_list.save
      redirect_to dashboard_path
    else
      render 'dashboard/index', status: :unprocessable_entity
    end
  end

  def update
    @user_movie_list = UserMovieList.find(params[:id])
    if @user_movie_list.update(user_movie_list_params)
      redirect_to dashboard_path
    else
      render 'dashboard/index', status: :unprocessable_entity
    end
  end

  def destroy
    @user_movie_list = UserMovieList.find(params[:id])
    if @user_movie_list.destroy
      redirect_to dashboard_path
    else
      render 'dashboard/index', status: :unprocessable_entity
    end
  end

  private

  def user_movie_list_params
    params.require(:user_movie_list).permit(:favorite, :watchlist)
  end

  def set_user_movie_list
    @user_movie_list = UserMovieList.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end
