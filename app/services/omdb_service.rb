# app/services/omdb_service.rb

class OmdbService
  include HTTParty
  BASE_URL = "http://www.omdbapi.com"

  MOOD_TAGS = {
    Action: 'Exciting',
    Adventure: 'Adventurous',
    Animation: 'Imaginative',
    Biography: 'Inspirational',
    Comedy: 'Funny',
    Crime: 'Thrilling',
    Documentary: 'Informative',
    Drama: 'Emotional',
    Family: 'Heartwarming',
    Fantasy: 'Magical',
    'Film-Noir': 'Mysterious',
    History: 'Educational',
    Horror: 'Scary',
    Music: 'Energetic',
    Musical: 'Melodious',
    Mystery: 'Puzzling',
    Romance: 'Romantic',
    'Sci-Fi': 'Futuristic',
    Sport: 'Motivating',
    Thriller: 'Suspenseful',
    War: 'Intense',
    Western: 'Rugged'
  }

  def self.search_movies(query)
    response = HTTParty.get(BASE_URL, query: { s: query, apikey: ENV['OMDB_API_KEY'] })
    movies_data = JSON.parse(response.body)['Search']

    if movies_data
      movies = movies_data.map do |data|
        details = get_movie_details(data['imdbID'])
        create_movie_object(details)
      end.compact
    else
      movies = []
    end
    movies
  end

  def self.search_movies_by_mood(mood, count = 10)
    # Find the corresponding genres for the given mood
    genres = MOOD_TAGS.select { |_, value| value == mood }.keys.map(&:to_s)

    # Initialize an empty array to store movie objects
    movies = []

    # Iterate through the genres and fetch movies
    genres.each do |genre|
      fetched_movies = search_movies_by_genre(genre, count)
      movies.concat(fetched_movies)
    end

    # Remove duplicate movies based on their IMDB ID
    movies.uniq! { |movie| movie.imdb_id }

    # Filter out movies without a poster
    movies_with_posters = movies.select { |movie| movie.poster_url != "N/A" }

    # Return the first `count` movies from the array
    movies_with_posters.first(count)
  end



  def self.create_movie_object(movie_data)
    return nil if movie_data['Poster'] == 'N/A'

    Movie.new(
      title: movie_data['Title'],
      year: movie_data['Year'],
      genre: movie_data['Genre'],
      poster_url: movie_data['Poster'],
      imdb_id: movie_data['imdbID'],
      mood_tag: map_genre_to_model(movie_data['Genre'])&.name
    )
  end

  def self.search_movies_by_genre(genre, count = 10)
    # Initialize an empty array to store movie objects
    movies = []

    # Fetch movies until the desired count is reached
    while movies.length < count
      # Fetch a random page of search results for the specified genre
      page = rand(1..10)

      # Cache the API response for a specific genre and page
      cache_key = "#{genre}-#{page}"
      movies_data = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
        response = HTTParty.get(BASE_URL, query: { s: genre, type: 'movie', page: page, apikey: ENV['OMDB_API_KEY'] })
        JSON.parse(response.body)['Search']
      end

      # Skip the current iteration if no movies were found
      next if movies_data.nil?

      # Create movie objects from the fetched data
      fetched_movies = movies_data.map do |data|
        details = get_movie_details(data['imdbID'])
        self.create_movie_object(details) if details.present?
      end.compact

      # Add the fetched movies to the array
      movies.concat(fetched_movies)

      # Remove duplicate movies based on their IMDB ID
      movies.uniq! { |movie| movie.imdb_id }
    end

    # Return the first `count` movies from the array
    movies.first(count)
  end



  def self.search_movie_by_id(imdb_id)
    response = HTTParty.get(BASE_URL, query: { i: imdb_id, apikey: ENV['OMDB_API_KEY'] })
    movie_data = JSON.parse(response.body)

    genre_names = movie_data['Genre'].split(", ").join(", ")
    mood_tags = genre_names.split(", ").map { |genre| MOOD_TAGS[genre.to_sym] }.compact.join(", ")

    Movie.new(
      title: movie_data['Title'],
      year: movie_data['Year'],
      genre: genre_names,
      mood_tag: mood_tags,
      imdb_id: movie_data['imdbID'],
      poster_url: movie_data['Poster']
    )
  end

  def self.map_genre_to_model(genre_name)
    Genre.find_by(name: genre_name)
  end

  def self.get_movie_details(imdb_id)
    # Cache the API response for a specific IMDB ID
    cache_key = "movie-details-#{imdb_id}"
    parsed_response = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      response = HTTParty.get("#{BASE_URL}?i=#{imdb_id}&apikey=#{ENV['OMDB_API_KEY']}")
      JSON.parse(response.body)
    end

    # Map genres to mood tags
    if parsed_response["Response"] == "True"
      genres = parsed_response["Genre"].split(", ")
      mood_tags = genres.map { |genre| MOOD_TAGS[genre.to_sym] }.compact
      parsed_response["Mood"] = mood_tags.join(", ")
    end

    parsed_response
  end
end
