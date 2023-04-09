class UserMovieListsController < ApplicationController
  def new
    @user_movie_list = UserMovieList.new
    @movie = Movie.find(params[:movie_id])
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

  def add_to_watchlist
    @movie = Movie.find(params[:movie_id])
    @user_movie_list = UserMovieList.new(user_id: current_user.id, movie_id: @movie.id, watchlist: true)

    if @user_movie_list.save
      redirect_to dashboard_path
    else
      @movie = Movie.find(params[:movie_id])
      render :new, status: :unprocessable_entity
    end
  end

  def create
    is_favorite = params[:user_movie_list][:is_favorite] == "1"

    if is_favorite
      add_to_favorites
    else
      add_to_watchlist
    end
  end

  def add_to_favorites
    @movie = Movie.find(params[:movie_id])
    @user_movie_list = UserMovieList.new(user_id: current_user.id, movie_id: @movie.id, is_favorite: true)

    if @user_movie_list.save
      redirect_to dashboard_path
    else
      @movie = Movie.find(params[:movie_id])
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    user_movie_list = current_user.user_movie_lists.find(params[:id])

    if user_movie_list.destroy
      flash[:notice] = "Movie removed from your list."
    else
      flash[:alert] = "An error occurred while removing the movie from your list."
    end

    redirect_to dashboard_path
  end


  private

  def user_movie_list_params
    params.require(:user_movie_list).permit(:is_favorite, :movie_id)
  end
end
