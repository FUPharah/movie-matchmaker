class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if params[:search].present?
      @movies = OmdbService.search_movies(params[:search])
    elsif params[:genre]
      @movies = OmdbService.search_movies_by_genre(params[:genre], 10)
    elsif params[:mood]
      @movies = OmdbService.search_movies_by_mood(params[:mood], 10)
    else
      # Replace the following movie titles with whatever selection of featured movies you want to display
      # Fetch featured movies
      featured_movie_titles = ['American Pie']
      @featured_movies = featured_movie_titles.map { |title| OmdbService.search_movies(title) }.flatten

      # Fetch movies by genre
      @action_movies = OmdbService.search_movies_by_genre('Action', 5)
      @romance_movies = OmdbService.search_movies_by_genre('Romance', 5)
      @comedy_movies = OmdbService.search_movies_by_genre('Comedy', 5)
    end
  end
end
