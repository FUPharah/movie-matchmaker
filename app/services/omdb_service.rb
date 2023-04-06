# app/services/omdb_service.rb

class OmdbService
  include HTTParty
  BASE_URL = "http://www.omdbapi.com"

  MOOD_TAGS = {
    'Action': 'Exciting',
    'Adventure': 'Adventurous',
    'Animation': 'Imaginative',
    'Biography': 'Inspirational',
    'Comedy': 'Funny',
    'Crime': 'Thrilling',
    'Documentary': 'Informative',
    'Drama': 'Emotional',
    'Family': 'Heartwarming',
    'Fantasy': 'Magical',
    'Film-Noir': 'Mysterious',
    'History': 'Educational',
    'Horror': 'Scary',
    'Music': 'Energetic',
    'Musical': 'Melodious',
    'Mystery': 'Puzzling',
    'Romance': 'Romantic',
    'Sci-Fi': 'Futuristic',
    'Sport': 'Motivating',
    'Thriller': 'Suspenseful',
    'War': 'Intense',
    'Western': 'Rugged'
  }

  def self.search_movies(query)
    response = HTTParty.get(BASE_URL, query: { s: query, apikey: ENV['OMDB_API_KEY'] })
    movies_data = JSON.parse(response.body)['Search']

    if movies_data
      movies = movies_data.map do |data|
        details = get_movie_details(data['imdbID'])

        genre_names = details['Genre'].split(", ").join(", ")
        mood_tags = genre_names.split(", ").map { |genre| MOOD_TAGS[genre.to_sym] }.compact.join(", ")

        Movie.new(
          title: data['Title'],
          year: data['Year'],
          imdb_id: data['imdbID'],
          type: data['Type'],
          poster_url: data['Poster'],
          genre: genre_names,
          mood_tag: mood_tags
        )
      end
    else
      movies = []
    end
      movies
  end


  def self.map_genre_to_model(genre_name)
    Genre.find_by(name: genre_name)
  end

  def self.get_movie_details(imdb_id)
    response = HTTParty.get("#{BASE_URL}?i=#{imdb_id}&apikey=#{ENV['OMDB_API_KEY']}")
    parsed_response = JSON.parse(response.body)

    # Map genres to mood tags
    if parsed_response["Response"] == "True"
      genres = parsed_response["Genre"].split(", ")
      mood_tags = genres.map { |genre| MOOD_TAGS[genre.to_sym] }.compact
      parsed_response["Mood"] = mood_tags.join(", ")
    end

    parsed_response
  end
end
