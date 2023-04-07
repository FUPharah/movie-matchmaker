class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def show
    imdb_id = params[:id]
    @movie = OmdbService.get_movie_details(imdb_id)
  end

  def show_by_imdb_id
    imdb_id = params[:imdb_id]
    @movie = OmdbService.get_movie_details(imdb_id)
    render :show
  end

  def search
    query = params[:query]
    @movies = OmdbService.get_movies(query)
  end

  def add_favorite
    @movie = Movie.find_by(imdb_id: params[:id])

    if @movie.nil?
      movie_details = OmdbService.get_movie_details(params[:id])
      if movie_details["Response"] == "True"
        @movie = Movie.create_from_omdb(movie_details)
      else
        flash[:alert] = "Error adding movie to favorites: #{movie_details['Error']}"
        redirect_to root_path and return
      end
    end

    user_movie_list = current_user.user_movie_lists.find_or_initialize_by(movie: @movie)
    user_movie_list.update(is_favorite: true)

    if user_movie_list.errors.any?
      flash[:alert] = "Error adding movie to favorites: #{user_movie_list.errors.full_messages.join(', ')}"
    else
      flash[:notice] = "Movie added to favorites"
    end

    redirect_to root_path
  end

  def add_watchlist
    @movie = Movie.find_by(imdb_id: params[:id])

    if @movie.nil?
      movie_details = OmdbService.get_movie_details(params[:id])
      if movie_details["Response"] == "True"
        @movie = Movie.create_from_omdb(movie_details)
      else
        flash[:alert] = "Error adding movie to watchlist: #{movie_details['Error']}"
        redirect_to root_path and return
      end
    end

    user_movie_list = current_user.user_movie_lists.find_or_initialize_by(movie: @movie)
    user_movie_list.update(watchlist: true)

    if user_movie_list.errors.any?
      flash[:alert] = "Error adding movie to watchlist: #{user_movie_list.errors.full_messages.join(', ')}"
    else
      flash[:notice] = "Movie added to watchlist"
    end

    redirect_to root_path
  end
end
