class UserMovieListsController < ApplicationController
  def new
    @user_movie_list = UserMovieList.new
    @movie = Movie.find(params[:movie_id])
  end

  def create
    @user_movie_list = UserMovieList.new(user_movie_list_params)
    @user_movie_list.user = current_user
    @user_movie_list.movie = Movie.find(params[:movie_id])

    if @user_movie_list.save
      redirect_to dashboard_path
    else
      @movie = Movie.find(params[:movie_id])
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user_movie_list = UserMovieList.find(params[:id])
    @movie = Movie.find(params[:movie_id])
  end

  def update
    @user_movie_list = UserMovieList.find(params[:id])
    if @user_movie_list.update(user_movie_list_params)
      redirect_to dashboard_path
    else
      @movie = Movie.find(params[:movie_id])
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_movie_list_params
    params.require(:user_movie_list).permit(:is_favorite, :movie_id)
  end
end
