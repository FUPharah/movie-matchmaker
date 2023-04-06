

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

  def self.get_movie_details(imdb_id)
    response = HTTParty.get("#{BASE_URL}/?apikey=#{API_KEY}&i=#{imdb_id}")
    movie = response.parsed_response
    movie['Mood'] = genre_to_mood(movie['Genre'])
    movie
  end

  def self.genre_to_mood(genre)
    genres = genre.split(', ')
    moods = genres.map { |g| MOOD_TAGS[g] }.compact
    moods.join(', ')
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
