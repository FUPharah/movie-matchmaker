class Movie < ApplicationRecord
  belongs_to :genre
  belongs_to :mood_tag
  has_many :ratings, dependent: :destroy
  has_many :user_movie_lists, dependent: :destroy
  has_many :users, through: :user_movie_lists, dependent: :destroy

  def self.create_from_omdb(movie_details)
    mood_tag_name = OmdbService.genre_to_mood(movie_details['Genre'])
    mood_tag_instance = MoodTag.find_or_create_by(name: mood_tag_name)
    movie = Movie.new(
      title: movie_details['Title'],
      year: movie_details['Year'],
      imdb_id: movie_details['imdbID'],
      poster_image_url: movie_details['Poster'],
      mood_tag: mood_tag_instance,
    )

    genre_name = movie_details['Genre'].split(',').first.strip
    genre = Genre.find_or_create_by(name: genre_name)

    movie.genre = genre
    movie.save
    movie
  end
end
